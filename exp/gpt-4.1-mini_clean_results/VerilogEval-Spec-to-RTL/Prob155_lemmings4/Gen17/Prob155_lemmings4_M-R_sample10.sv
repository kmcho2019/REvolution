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

    // Combined mode-direction states:
    // 4 modes * 2 directions = 8 states
    typedef enum logic [2:0] {
        WLK_L = 3'd0,
        WLK_R = 3'd1,
        DIG_L = 3'd2,
        DIG_R = 3'd3,
        FAL_L = 3'd4,
        FAL_R = 3'd5,
        SPLAT = 3'd6
    } state_t;

    state_t state, next_state;

    // Fall timer counts fall duration when falling
    reg [4:0] fall_timer, next_fall_timer;

    // Compute fall_too_long combinationally to avoid extra reg and toggle
    wire fall_too_long = (fall_timer > 5'd20);

    // Sequential logic: async reset on posedge areset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WLK_L;       // Walk left on reset
            fall_timer <= 5'd0;
        end else begin
            state <= next_state;
            fall_timer <= next_fall_timer;
        end
    end

    // Combinational next state and fall_timer logic
    always @(*) begin
        // Default assignments
        next_state = state;
        next_fall_timer = 5'd0;

        case (state)
            SPLAT: begin
                // Remain splatted forever
                next_state = SPLAT;
                next_fall_timer = 5'd0;
            end
            FAL_L, FAL_R: begin
                // Falling states
                if (ground) begin
                    // Landed: splat if fallen too long, else walk in previous direction
                    if (fall_too_long)
                        next_state = SPLAT;
                    else if (state == FAL_L)
                        next_state = WLK_L;
                    else
                        next_state = WLK_R;
                    next_fall_timer = 5'd0;
                end else begin
                    // Continue falling, increment timer
                    next_state = state;
                    next_fall_timer = fall_timer + 1'b1;
                end
            end
            WLK_L, WLK_R: begin
                // Walking states
                if (!ground) begin
                    // Fall takes precedence
                    next_state = (state == WLK_L) ? FAL_L : FAL_R;
                    next_fall_timer = 5'd1; // start fall count
                end else if (dig) begin
                    // Start digging
                    next_state = (state == WLK_L) ? DIG_L : DIG_R;
                    next_fall_timer = 5'd0;
                end else begin
                    // Handle bumps
                    if (bump_left || bump_right) begin
                        if (bump_left && bump_right) begin
                            // Both bumps: reverse direction
                            next_state = (state == WLK_L) ? WLK_R : WLK_L;
                        end else if (bump_left) begin
                            // Bumped left, walk right
                            next_state = WLK_R;
                        end else begin
                            // Bumped right, walk left
                            next_state = WLK_L;
                        end
                    end else begin
                        next_state = state; // keep direction
                    end
                    next_fall_timer = 5'd0;
                end
            end
            DIG_L, DIG_R: begin
                // Digging states
                if (!ground) begin
                    // No ground => start falling
                    next_state = (state == DIG_L) ? FAL_L : FAL_R;
                    next_fall_timer = 5'd1;
                end else begin
                    // Continue digging; bumps and dig input ignored
                    next_state = state;
                    next_fall_timer = 5'd0;
                end
            end
            default: begin
                // Defensive fallback
                next_state = WLK_L;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Moore outputs depend on current state
    assign walk_left  = (state == WLK_L);
    assign walk_right = (state == WLK_R);
    assign aaah       = (state == FAL_L) || (state == FAL_R);
    assign digging    = (state == DIG_L) || (state == DIG_R);

endmodule