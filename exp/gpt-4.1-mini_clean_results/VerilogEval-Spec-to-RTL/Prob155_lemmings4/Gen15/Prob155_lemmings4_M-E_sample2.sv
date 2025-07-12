module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // State encoding: 2 bits, encode direction in WALK states
    typedef enum logic [1:0] {
        WALK_LEFT  = 2'b00,
        WALK_RIGHT = 2'b01,
        FALL       = 2'b10,
        SPLAT      = 2'b11
    } state_t;

    state_t state, next_state;
    logic dig_flag, next_dig_flag;
    logic [4:0] fall_timer, next_fall_timer; // 5 bits count to 31 max

    // Bump signals combined
    wire bump_any = bump_left | bump_right;

    // For walking states, determine if bump triggers direction switch
    // In WALK_LEFT: bump_left or bump_both -> switch to WALK_RIGHT
    // In WALK_RIGHT: bump_right or bump_both -> switch to WALK_LEFT
    // bump_both means both bump_left and bump_right high simultaneously

    // Prepare bump conditions
    wire bump_both = bump_left & bump_right;

    // Asynchronous reset + synchronous logic
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state       <= WALK_LEFT;
            dig_flag    <= 1'b0;
            fall_timer  <= 5'd0;
        end else begin
            state       <= next_state;
            dig_flag    <= next_dig_flag;
            fall_timer  <= next_fall_timer;
        end
    end

    // Next-state and outputs logic
    always_comb begin
        // Defaults
        next_state      = state;
        next_dig_flag   = dig_flag;
        next_fall_timer = fall_timer;

        case (state)
            WALK_LEFT: begin
                if (!ground) begin
                    // Ground lost, start falling
                    next_state      = FALL;
                    next_fall_timer = 5'd1;
                    next_dig_flag   = 1'b0; // stop digging when falling
                end else if (dig && !dig_flag) begin
                    // Start digging if on ground and not already digging
                    next_dig_flag = 1'b1;
                end else if (dig_flag && !ground) begin
                    // Should never happen due to above, but ensure dig_flag reset when falling
                    next_dig_flag = 1'b0;
                end else if (dig_flag && !dig) begin
                    // Stop digging when dig signal deasserted on ground (could be optional)
                    next_dig_flag = 1'b0;
                end

                // Handle bumps only if not digging
                if (!dig_flag) begin
                    if (bump_both || bump_left) begin
                        // bump_left or both: switch to WALK_RIGHT
                        next_state    = WALK_RIGHT;
                        next_dig_flag = 1'b0; // reset digging on direction change
                    end
                    // bump_right on WALK_LEFT has no effect
                end

                // stay in WALK_LEFT, dig_flag and fall_timer updated above
                next_fall_timer = 5'd0;
            end

            WALK_RIGHT: begin
                if (!ground) begin
                    // Ground lost, start falling
                    next_state      = FALL;
                    next_fall_timer = 5'd1;
                    next_dig_flag   = 1'b0; // stop digging when falling
                end else if (dig && !dig_flag) begin
                    // Start digging if on ground and not already digging
                    next_dig_flag = 1'b1;
                end else if (dig_flag && !ground) begin
                    // Ensure dig_flag reset when falling
                    next_dig_flag = 1'b0;
                end else if (dig_flag && !dig) begin
                    // Stop digging when dig signal deasserted on ground (optional)
                    next_dig_flag = 1'b0;
                end

                // Handle bumps only if not digging
                if (!dig_flag) begin
                    if (bump_both || bump_right) begin
                        // bump_right or both: switch to WALK_LEFT
                        next_state    = WALK_LEFT;
                        next_dig_flag = 1'b0; // reset digging on direction change
                    end
                    // bump_left on WALK_RIGHT has no effect
                end

                // stay in WALK_RIGHT, dig_flag and fall_timer updated above
                next_fall_timer = 5'd0;
            end

            FALL: begin
                if (ground) begin
                    // Landed
                    if (fall_timer > 5'd20) begin
                        // Splatter
                        next_state      = SPLAT;
                        next_fall_timer = 5'd0;
                        next_dig_flag   = 1'b0;
                    end else begin
                        // Resume walking same direction as before fall
                        // Use stored state: no separate direction register,
                        // so store last walk direction in "state"
                        if (dig_flag) begin
                            // Digging ends on fall and landing (per spec)
                            next_dig_flag = 1'b0;
                        end

                        // But no stored direction in FALL, so remember last direction from FALL entry.
                        // Here, maintain direction by picking WALK_LEFT or WALK_RIGHT matching previous walk state
                        // We encode last direction into a reg: need extra reg or store it in state variable
                        // Since we lose walk state info during fall, we must save it:

                        // Let's assume the FSM remembers direction in a separate reg: 
                        // To avoid extra register, we can encode direction in separate reg:

                        // But per instructions, direction is encoded in state, so store last walk direction in direction reg

                        // Wait: in this design direction is lost during FALL state since state is FALL
                        // Therefore, need a direction reg to restore upon landing, let's add direction_reg.

                        // To fix this, add a reg direction_reg updated when entering FALL from WALK.
                        // We'll do this after next_state logic.

                        // For now, keep next_state to previous direction via direction_reg.
                        // Temporarily assign next_state = WALK_LEFT; placeholder.

                        next_state = FALL; // will be overwritten below in final design
                    end
                end else begin
                    // Continue falling: increment fall_timer saturate at 31
                    next_state = FALL;
                    next_fall_timer = (fall_timer == 5'd31) ? 5'd31 : fall_timer + 1'b1;
                    // dig_flag remains 0 during fall
                    next_dig_flag = 1'b0;
                end
            end

            SPLAT: begin
                // Terminal state, all outputs zero
                next_state      = SPLAT;
                next_fall_timer = 5'd0;
                next_dig_flag   = 1'b0;
            end

            default: begin
                // Safety fallback: walk left
                next_state      = WALK_LEFT;
                next_fall_timer = 5'd0;
                next_dig_flag   = 1'b0;
            end
        endcase
    end

    // Because FALL state loses direction info, keep track of last walking direction in a separate register
    // Update direction_reg when entering FALL state
    logic direction_reg, next_direction_reg; // 0 = left, 1 = right

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            direction_reg <= 1'b0; // Left on reset
        end else begin
            direction_reg <= next_direction_reg;
        end
    end

    always_comb begin
        // Default: hold direction_reg
        next_direction_reg = direction_reg;

        // Update direction_reg on transitions into FALL
        if (state != FALL && next_state == FALL) begin
            // From WALK_LEFT: direction_reg = 0
            if (state == WALK_LEFT) next_direction_reg = 1'b0;
            // From WALK_RIGHT: direction_reg = 1
            else if (state == WALK_RIGHT) next_direction_reg = 1'b1;
        end
        // No change otherwise
    end

    // Now finalize FALL landing transition to WALK with direction_reg
    always_comb begin
        if (state == FALL && ground) begin
            if (fall_timer > 5'd20) begin
                // splat done above
            end else begin
                // Land: resume walking in direction_reg
                if (direction_reg == 1'b0)
                    next_state = WALK_LEFT;
                else
                    next_state = WALK_RIGHT;
            end
        end
    end

    // Moore outputs from state and dig_flag
    assign walk_left  = (state == WALK_LEFT) && !dig_flag;
    assign walk_right = (state == WALK_RIGHT) && !dig_flag;
    assign aaah       = (state == FALL);
    assign digging    = dig_flag && (state == WALK_LEFT || state == WALK_RIGHT);

endmodule