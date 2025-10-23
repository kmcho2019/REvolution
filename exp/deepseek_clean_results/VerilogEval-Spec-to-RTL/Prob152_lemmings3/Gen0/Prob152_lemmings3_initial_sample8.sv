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

    // Define states
    parameter WALK_LEFT = 3'd0;
    parameter WALK_RIGHT = 3'd1;
    parameter FALLING_LEFT = 3'd2;
    parameter FALLING_RIGHT = 3'd3;
    parameter DIGGING_LEFT = 3'd4;
    parameter DIGGING_RIGHT = 3'd5;

    reg [2:0] state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            WALK_LEFT: begin
                if (!ground)
                    next_state = FALLING_LEFT;
                else if (dig)
                    next_state = DIGGING_LEFT;
                else if (bump_left)
                    next_state = WALK_RIGHT;
                else
                    next_state = WALK_LEFT;
            end
            WALK_RIGHT: begin
                if (!ground)
                    next_state = FALLING_RIGHT;
                else if (dig)
                    next_state = DIGGING_RIGHT;
                else if (bump_right)
                    next_state = WALK_LEFT;
                else
                    next_state = WALK_RIGHT;
            end
            FALLING_LEFT: begin
                if (ground)
                    next_state = WALK_LEFT;
                else
                    next_state = FALLING_LEFT;
            end
            FALLING_RIGHT: begin
                if (ground)
                    next_state = WALK_RIGHT;
                else
                    next_state = FALLING_RIGHT;
            end
            DIGGING_LEFT: begin
                if (!ground)
                    next_state = FALLING_LEFT;
                else
                    next_state = DIGGING_LEFT;
            end
            DIGGING_RIGHT: begin
                if (!ground)
                    next_state = FALLING_RIGHT;
                else
                    next_state = DIGGING_RIGHT;
            end
            default: next_state = WALK_LEFT;
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk, posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Output logic
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALLING_LEFT) || (state == FALLING_RIGHT);
    assign digging = (state == DIGGING_LEFT) || (state == DIGGING_RIGHT);

endmodule