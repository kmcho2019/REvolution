module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    output reg  walk_left,
    output reg  walk_right
);

    // State encoding
    typedef enum logic {
        WALK_LEFT  = 1'b0,
        WALK_RIGHT = 1'b1
    } state_t;

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        case(state)
            WALK_LEFT: begin
                // If bumped on left or right (or both), switch to walk right
                if (bump_left || bump_right)
                    next_state = WALK_RIGHT;
                else
                    next_state = WALK_LEFT;
            end
            WALK_RIGHT: begin
                // If bumped on left or right (or both), switch to walk left
                if (bump_left || bump_right)
                    next_state = WALK_LEFT;
                else
                    next_state = WALK_RIGHT;
            end
            default: next_state = WALK_LEFT;
        endcase
    end

    // State register with asynchronous active high reset
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
                walk_left  = 1'b1;
                walk_right = 1'b0;
            end
            WALK_RIGHT: begin
                walk_left  = 1'b0;
                walk_right = 1'b1;
            end
            default: begin
                walk_left  = 1'b1;
                walk_right = 1'b0;
            end
        endcase
    end

endmodule