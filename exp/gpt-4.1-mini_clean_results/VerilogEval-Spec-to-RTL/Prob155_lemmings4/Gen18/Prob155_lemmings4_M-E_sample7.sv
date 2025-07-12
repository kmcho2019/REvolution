module TopModule (
    input  clk,
    input  areset,       // asynchronous active high reset
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // Enumerated combined states: mode + direction
    typedef enum logic [2:0] {
        WLK_L = 3'd0, // walking left
        WLK_R = 3'd1, // walking right
        DIG_L = 3'd2, // digging left
        DIG_R = 3'd3, // digging right
        FAL_L = 3'd4, // falling left
        FAL_R = 3'd5, // falling right
        SPLAT = 3'd6  // splattered, terminal state
    } state_t;

    state_t state, next_state;

    // Fall timer counts how many cycles the Lemming has fallen; 0 when not falling
    reg [4:0] fall_count, next_fall_count;

    // Async reset, synchronous state and counter update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WLK_L;
            fall_count <= 5'd0;
        end else begin
            state <= next_state;
            fall_count <= next_fall_count;
        end
    end

    // Helper function: get direction bit from walking/digging/falling state
    // 0 for left, 1 for right
    function logic get_dir(input state_t s);
        case (s)
            WLK_L, DIG_L, FAL_L: get_dir = 1'b0;
            WLK_R, DIG_R, FAL_R: get_dir = 1'b1;
            default: get_dir = 1'b0; // For SPLAT, arbitrary
        endcase
    endfunction

    // Determine next state based on current state, inputs, and fall count
    always @(*) begin
        // Default next state and fall counter
        next_state = state;
        next_fall_count = (state == FAL_L || state == FAL_R) ? fall_count + 1'b1 : 5'd0;

        case (state)
            SPLAT: begin
                // Terminal state, no transitions out
                next_state = SPLAT;
                next_fall_count = 5'd0;
            end

            // FALLING states
            FAL_L, FAL_R: begin
                if (ground) begin
                    // Landing on ground: if fall_count > 20 splat, else walk in same direction
                    if (fall_count > 5'd20)
                        next_state = SPLAT;
                    else begin
                        if (state == FAL_L)
                            next_state = WLK_L;
                        else
                            next_state = WLK_R;
                    end
                    next_fall_count = 5'd0;
                end else begin
                    // Continue falling
                    next_state = state;
                    // fall_count incremented above
                end
                // Bumps and dig inputs ignored while falling
            end

            // DIGGING states
            DIG_L, DIG_R: begin
                if (!ground) begin
                    // No ground while digging => start falling in current direction
                    next_state = (state == DIG_L) ? FAL_L : FAL_R;
                    next_fall_count = 5'd1;
                end else begin
                    // Continue digging while on ground; ignore bumps and dig inputs
                    next_state = state;
                    next_fall_count = 5'd0;
                end
            end

            // WALKING states
            WLK_L, WLK_R: begin
                if (!ground) begin
                    // Fall takes precedence
                    next_state = (state == WLK_L) ? FAL_L : FAL_R;
                    next_fall_count = 5'd1;
                end else if (dig) begin
                    // Start digging on ground and dig command active
                    next_state = (state == WLK_L) ? DIG_L : DIG_R;
                    next_fall_count = 5'd0;
                end else begin
                    // Handle bumps: if bumped left or right, switch walking direction accordingly
                    // Both bumps or either bump cause direction switch per spec
                    if (bump_left || bump_right) begin
                        // On bump_left or bump_right (or both), switch direction
                        if (state == WLK_L) begin
                            // walking left bumped => switch to walking right
                            next_state = WLK_R;
                        end else begin
                            // walking right bumped => switch to walking left
                            next_state = WLK_L;
                        end
                    end else begin
                        // No bumps => stay walking same direction
                        next_state = state;
                    end
                    next_fall_count = 5'd0;
                end
            end

            default: begin
                // Defensive fallback: walk left
                next_state = WLK_L;
                next_fall_count = 5'd0;
            end
        endcase
    end

    // Moore outputs from state
    assign walk_left  = (state == WLK_L);
    assign walk_right = (state == WLK_R);
    assign digging    = (state == DIG_L) || (state == DIG_R);
    assign aaah       = (state == FAL_L) || (state == FAL_R);

endmodule