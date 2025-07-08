module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);
    // State encoding
    typedef enum reg [2:0] {
        WALK_LEFT = 3'd0,
        WALK_RIGHT = 3'd1,
        FALL_LEFT = 3'd2,
        FALL_RIGHT = 3'd3,
        DIG_LEFT = 3'd4,
        DIG_RIGHT = 3'd5,
        SPLAT = 3'd6
    } state_t;

    state_t state, next_state;

    reg [4:0] fall_counter; // 5 bits to count >20 cycles

    // Combinational logic to compute next state
    always @(*) begin
        // Default next state is current state
        next_state = state;

        case(state)
            SPLAT: begin
                // Remain splatted forever
                next_state = SPLAT;
            end

            FALL_LEFT, FALL_RIGHT: begin
                // When falling and ground appears, check for splat or resume walking
                if (ground) begin
                    if (fall_counter > 20) begin
                        next_state = SPLAT;
                    end else begin
                        // Resume walking same direction as fall
                        next_state = (state == FALL_LEFT) ? WALK_LEFT : WALK_RIGHT;
                    end
                end else begin
                    // Continue falling
                    next_state = state;
                end
            end

            DIG_LEFT, DIG_RIGHT: begin
                // If ground disappears while digging, start falling in same direction
                if (!ground) begin
                    next_state = (state == DIG_LEFT) ? FALL_LEFT : FALL_RIGHT;
                end else begin
                    // Continue digging while ground present
                    next_state = state;
                end
            end

            WALK_LEFT, WALK_RIGHT: begin
                // Check for ground first - fall has highest priority
                if (!ground) begin
                    // Start falling in current walking direction
                    next_state = (state == WALK_LEFT) ? FALL_LEFT : FALL_RIGHT;
                end else if (dig) begin
                    // Start digging in current walking direction
                    next_state = (state == WALK_LEFT) ? DIG_LEFT : DIG_RIGHT;
                end else begin
                    // Switching directions if bumped
                    // bump_left means bump on left, cause walk right
                    // bump_right means bump on right, cause walk left
                    // if both bumped at once still switch directions
                    if (bump_left || bump_right) begin
                        // switch direction
                        next_state = (state == WALK_LEFT) ? WALK_RIGHT : WALK_LEFT;
                    end else begin
                        // no bump, continue walking same direction
                        next_state = state;
                    end
                end
            end

            default: begin
                // Should not happen, default to WALK_LEFT
                next_state = WALK_LEFT;
            end
        endcase
    end

    // Sequential logic: state update and fall_counter
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_counter <= 0;
        end else begin
            state <= next_state;

            if (next_state == FALL_LEFT || next_state == FALL_RIGHT) begin
                fall_counter <= fall_counter + 1;
            end else begin
                fall_counter <= 0;
            end
        end
    end

    // Output logic: Moore machine
    always @(*) begin
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        digging = 1'b0;

        case(state)
            WALK_LEFT: begin
                walk_left = 1'b1;
            end
            WALK_RIGHT: begin
                walk_right = 1'b1;
            end
            FALL_LEFT, FALL_RIGHT: begin
                aaah = 1'b1;
            end
            DIG_LEFT, DIG_RIGHT: begin
                digging = 1'b1;
            end
            SPLAT: begin
                // all outputs zero
            end
        endcase
    end

endmodule