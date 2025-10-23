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

    // State encoding with direction embedded in walking and digging states
    typedef enum logic [3:0] {
        WALK_LEFT  = 4'd0,
        WALK_RIGHT = 4'd1,
        DIG_LEFT   = 4'd2,
        DIG_RIGHT  = 4'd3,
        FALL       = 4'd4,
        SPLAT      = 4'd5
    } state_t;

    state_t state, next_state;
    logic [4:0] fall_timer, next_fall_timer;

    // Keep track of last walking direction while falling and splatting
    // 0 = left, 1 = right
    logic last_dir, next_last_dir;

    // Combined bump signals
    wire bump_any = bump_left | bump_right;
    wire bump_both = bump_left & bump_right;

    // Whether current state is walking
    wire walking = (state == WALK_LEFT) || (state == WALK_RIGHT);

    // Whether current state is digging
    wire digging_state = (state == DIG_LEFT) || (state == DIG_RIGHT);

    // Whether currently falling
    wire falling = (state == FALL);

    // Splat condition: fall timer exceeded 20
    wire splat_condition = (fall_timer > 5'd20);

    // Update state and registers on clock posedge with async reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state       <= WALK_LEFT;
            fall_timer  <= 5'd0;
            last_dir    <= 1'b0; // left
        end else begin
            state       <= next_state;
            fall_timer  <= next_fall_timer;
            last_dir    <= next_last_dir;
        end
    end

    // Next state and fall timer logic
    always_comb begin
        next_state      = state;
        next_fall_timer = fall_timer;
        next_last_dir   = last_dir;

        // Helper signals for direction flips
        logic new_dir_left, new_dir_right;
        // Current direction based on state
        logic current_dir_left = (state == WALK_LEFT) || (state == DIG_LEFT);
        logic current_dir_right = (state == WALK_RIGHT) || (state == DIG_RIGHT);

        // Handle transitions based on state
        case (state)
            WALK_LEFT, WALK_RIGHT: begin
                // Determine current direction
                logic dir = (state == WALK_RIGHT);

                if (!ground) begin
                    // Falling starts, retain direction in last_dir
                    next_state = FALL;
                    next_fall_timer = 5'd1;
                    next_last_dir = dir;
                end else if (dig) begin
                    // Start digging only if on ground and walking
                    next_state = (dir) ? DIG_RIGHT : DIG_LEFT;
                    next_fall_timer = 5'd0;
                    next_last_dir = dir;
                end else begin
                    // Handle bump-induced direction change with priority for both bumps
                    if (bump_both) begin
                        // toggle direction
                        if (dir == 1'b0)
                            next_state = WALK_RIGHT;
                        else
                            next_state = WALK_LEFT;
                        next_last_dir = (dir == 1'b0) ? 1'b1 : 1'b0;
                        next_fall_timer = 5'd0;
                    end else if (bump_left) begin
                        // bump left => walk right
                        next_state = WALK_RIGHT;
                        next_last_dir = 1'b1;
                        next_fall_timer = 5'd0;
                    end else if (bump_right) begin
                        // bump right => walk left
                        next_state = WALK_LEFT;
                        next_last_dir = 1'b0;
                        next_fall_timer = 5'd0;
                    end else begin
                        // no bump, continue walking same direction
                        next_state = state;
                        next_last_dir = dir;
                        next_fall_timer = 5'd0;
                    end
                end
            end

            DIG_LEFT, DIG_RIGHT: begin
                // Direction embedded in state
                logic dir = (state == DIG_RIGHT);

                if (!ground) begin
                    // Ground lost, start falling
                    next_state = FALL;
                    next_fall_timer = 5'd1;
                    next_last_dir = dir;
                end else begin
                    // Keep digging on ground, ignore bumps and dig input
                    next_state = state;
                    next_fall_timer = 5'd0;
                    next_last_dir = dir;
                end
            end

            FALL: begin
                // During falling, direction remains in last_dir
                if (ground) begin
                    // Landed: check splat condition
                    if (splat_condition) begin
                        next_state = SPLAT;
                        next_fall_timer = 5'd0;
                        // last_dir unchanged, splat freezes output
                        next_last_dir = last_dir;
                    end else begin
                        // Back to walking in last direction
                        if (last_dir == 1'b0)
                            next_state = WALK_LEFT;
                        else
                            next_state = WALK_RIGHT;
                        next_fall_timer = 5'd0;
                        next_last_dir = last_dir;
                    end
                end else begin
                    // Continue falling, saturate timer at 31
                    next_state = FALL;
                    next_fall_timer = (fall_timer == 5'd31) ? 5'd31 : fall_timer + 1'b1;
                    next_last_dir = last_dir;
                end
            end

            SPLAT: begin
                // Lemming is dead/splatted, no outputs until reset
                next_state = SPLAT;
                next_fall_timer = 5'd0;
                // last_dir preserved but unused
                next_last_dir = last_dir;
            end

            default: begin
                // Should not happen; reset to safe defaults
                next_state = WALK_LEFT;
                next_fall_timer = 5'd0;
                next_last_dir = 1'b0;
            end
        endcase
    end

    // Moore outputs depend on current state and last_dir for fall/splat

    // walk_left when walking left and not splatted/falling/digging
    assign walk_left  = (state == WALK_LEFT);
    // walk_right when walking right and not splatted/falling/digging
    assign walk_right = (state == WALK_RIGHT);

    // digging high in digging states only
    assign digging   = (state == DIG_LEFT) || (state == DIG_RIGHT);

    // aaah high only during fall state
    assign aaah      = (state == FALL);

endmodule