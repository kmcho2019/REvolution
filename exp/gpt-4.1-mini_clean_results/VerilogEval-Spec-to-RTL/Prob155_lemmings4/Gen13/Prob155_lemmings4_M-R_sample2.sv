module TopModule (
    input  clk,
    input  areset,       // asynchronous posedge reset
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // State encoding with direction embedded:
    // 0: WALK_LEFT, 1: WALK_RIGHT, 2: DIG_LEFT, 3: DIG_RIGHT,
    // 4: FALL_LEFT, 5: FALL_RIGHT, 6: SPLAT
    typedef enum logic [2:0] {
        WALK_L = 3'd0,
        WALK_R = 3'd1,
        DIG_L  = 3'd2,
        DIG_R  = 3'd3,
        FALL_L = 3'd4,
        FALL_R = 3'd5,
        SPLAT  = 3'd6
    } state_t;

    state_t state, next_state;

    // Fall timer counts cycles in fall state, saturates at 31
    logic [4:0] fall_timer, next_fall_timer;

    // Bump combined signals
    wire bump_any  = bump_left | bump_right;
    wire bump_both = bump_left & bump_right;

    // Asynchronous reset with synchronous logic for state and timer
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state       <= WALK_L;     // reset to walking left
            fall_timer  <= 5'd0;
        end else begin
            state       <= next_state;
            fall_timer  <= next_fall_timer;
        end
    end

    // Next state and fall timer logic
    always_comb begin
        // Defaults: hold state, reset fall_timer except in fall
        next_state       = state;
        next_fall_timer  = 5'd0;

        // Helper to extract direction from state (0:left,1:right)
        logic dir_left = (state == WALK_L) || (state == DIG_L) || (state == FALL_L);

        // Priority: fall > dig > bump (when walking and on ground)

        case (state)
            SPLAT: begin
                // Remain splatted forever
                next_state      = SPLAT;
                next_fall_timer = 5'd0;
            end

            FALL_L, FALL_R: begin
                // In falling state, ignore bumps and dig inputs
                if (ground) begin
                    // Landed: if fall time >20, splat else resume walk in same direction
                    if (fall_timer > 5'd20)
                        next_state = SPLAT;
                    else
                        next_state = dir_left ? WALK_L : WALK_R;
                    next_fall_timer = 5'd0;
                end else begin
                    // Still falling: increment timer saturating at 31
                    next_state = state;
                    next_fall_timer = (fall_timer == 5'd31) ? 5'd31 : fall_timer + 1'b1;
                end
            end

            DIG_L, DIG_R: begin
                // If ground lost, start falling preserving direction
                if (!ground) begin
                    next_state = dir_left ? FALL_L : FALL_R;
                    next_fall_timer = 5'd1; // start fall count at 1
                end else begin
                    // Continue digging, ignore bumps and dig input
                    next_state = state;
                    next_fall_timer = 5'd0;
                end
            end

            WALK_L, WALK_R: begin
                if (!ground) begin
                    // Ground lost: start falling in current direction
                    next_state = dir_left ? FALL_L : FALL_R;
                    next_fall_timer = 5'd1;
                end else if (dig) begin
                    // Start digging if dig input high and on ground
                    next_state = dir_left ? DIG_L : DIG_R;
                    next_fall_timer = 5'd0;
                end else begin
                    // Handle bumps: direction switches accordingly
                    if (bump_both) begin
                        // Both bumped: toggle direction walking state
                        next_state = dir_left ? WALK_R : WALK_L;
                    end else if (bump_left) begin
                        // Bumped left: walk right
                        next_state = WALK_R;
                    end else if (bump_right) begin
                        // Bumped right: walk left
                        next_state = WALK_L;
                    end else begin
                        // No bump, continue walking in same direction
                        next_state = state;
                    end
                    next_fall_timer = 5'd0;
                end
            end

            default: begin
                // Default fallback to walk left
                next_state = WALK_L;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Outputs are Moore outputs depending only on state
    assign walk_left  = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign digging    = (state == DIG_L) || (state == DIG_R);
    assign aaah       = (state == FALL_L) || (state == FALL_R);

endmodule