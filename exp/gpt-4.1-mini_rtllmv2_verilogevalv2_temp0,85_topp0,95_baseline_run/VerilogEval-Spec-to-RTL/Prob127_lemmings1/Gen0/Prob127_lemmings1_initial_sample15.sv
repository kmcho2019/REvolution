module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

    typedef enum logic {WALK_LEFT, WALK_RIGHT} state_t;
    state_t state, next_state;

    // Next state logic
    always @(*) begin
        case(state)
            WALK_LEFT: begin
                // If bumped on left or right, switch to WALK_RIGHT
                if (bump_left || bump_right)
                    next_state = WALK_RIGHT;
                else
                    next_state = WALK_LEFT;
            end
            WALK_RIGHT: begin
                // If bumped on left or right, switch to WALK_LEFT
                if (bump_left || bump_right)
                    next_state = WALK_LEFT;
                else
                    next_state = WALK_RIGHT;
            end
            default: next_state = WALK_LEFT;
        endcase
    end

    // State register with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Output logic (Moore)
    always @(*) begin
        case(state)
            WALK_LEFT: begin
                walk_left = 1'b1;
                walk_right = 1'b0;
            end
            WALK_RIGHT: begin
                walk_left = 1'b0;
                walk_right = 1'b1;
            end
            default: begin
                walk_left = 1'b1;
                walk_right = 1'b0;
            end
        endcase
    end

endmodule