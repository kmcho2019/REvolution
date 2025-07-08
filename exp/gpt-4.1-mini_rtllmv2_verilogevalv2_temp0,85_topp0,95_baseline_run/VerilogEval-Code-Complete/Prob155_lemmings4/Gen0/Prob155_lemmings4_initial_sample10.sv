module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    typedef enum logic [2:0] {
        WALK_LEFT   = 3'd0,
        WALK_RIGHT  = 3'd1,
        DIG_LEFT    = 3'd2,
        DIG_RIGHT   = 3'd3,
        FALL_LEFT   = 3'd4,
        FALL_RIGHT  = 3'd5,
        SPLATTERED  = 3'd6
    } state_t;

    state_t state, next_state;
    logic [5:0] fall_time, next_fall_time; // 6 bits to count beyond 20 cycles

    // State register and fall_time register with async reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_time <= 6'd0;
        end else begin
            state <= next_state;
            fall_time <= next_fall_time;
        end
    end

    // Next state logic and fall_time update
    always_comb begin
        // Defaults
        next_state = state;
        next_fall_time = fall_time;

        case (state)
            SPLATTERED: begin
                // Terminal state, no transitions out
                next_state = SPLATTERED;
                next_fall_time = 6'd0;
            end

            WALK_LEFT: begin
                // Priority: fall > dig > bump switch direction > stay
                if (ground == 0) begin
                    next_state = FALL_LEFT;
                    next_fall_time = 6'd1;
                end else if (dig) begin
                    // dig only if ground=1 and not falling
                    next_state = DIG_LEFT;
                    next_fall_time = 6'd0;
                end else if (bump_left || bump_right) begin
                    // switch direction
                    next_state = WALK_RIGHT;
                    next_fall_time = 6'd0;
                end else begin
                    next_state = WALK_LEFT;
                    next_fall_time = 6'd0;
                end
            end

            WALK_RIGHT: begin
                if (ground == 0) begin
                    next_state = FALL_RIGHT;
                    next_fall_time = 6'd1;
                end else if (dig) begin
                    next_state = DIG_RIGHT;
                    next_fall_time = 6'd0;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_LEFT;
                    next_fall_time = 6'd0;
                end else begin
                    next_state = WALK_RIGHT;
                    next_fall_time = 6'd0;
                end
            end

            DIG_LEFT: begin
                // continue digging while ground=1
                // if ground=0 start falling with same direction
                if (ground == 0) begin
                    next_state = FALL_LEFT;
                    next_fall_time = 6'd1;
                end else begin
                    // ignore bump and dig inputs during digging
                    next_state = DIG_LEFT;
                    next_fall_time = 6'd0;
                end
            end

            DIG_RIGHT: begin
                if (ground == 0) begin
                    next_state = FALL_RIGHT;
                    next_fall_time = 6'd1;
                end else begin
                    next_state = DIG_RIGHT;
                    next_fall_time = 6'd0;
                end
            end

            FALL_LEFT: begin
                if (ground == 0) begin
                    // still falling, increment fall_time
                    next_state = FALL_LEFT;
                    if (fall_time == 6'd63) // prevent overflow
                        next_fall_time = 6'd63;
                    else
                        next_fall_time = fall_time + 6'd1;
                end else begin
                    // landed
                    if (fall_time > 6'd20) begin
                        // splatter
                        next_state = SPLATTERED;
                        next_fall_time = 6'd0;
                    end else begin
                        // resume walking left
                        next_state = WALK_LEFT;
                        next_fall_time = 6'd0;
                    end
                end
            end

            FALL_RIGHT: begin
                if (ground == 0) begin
                    next_state = FALL_RIGHT;
                    if (fall_time == 6'd63)
                        next_fall_time = 6'd63;
                    else
                        next_fall_time = fall_time + 6'd1;
                end else begin
                    if (fall_time > 6'd20) begin
                        next_state = SPLATTERED;
                        next_fall_time = 6'd0;
                    end else begin
                        next_state = WALK_RIGHT;
                        next_fall_time = 6'd0;
                    end
                end
            end

            default: begin
                // Should not occur; reset to WALK_LEFT
                next_state = WALK_LEFT;
                next_fall_time = 6'd0;
            end
        endcase
    end

    // Outputs: Moore machine outputs depend only on state
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign digging    = (state == DIG_LEFT) || (state == DIG_RIGHT);
    assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);

endmodule