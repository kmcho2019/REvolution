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

    // State definitions
    parameter LEFT = 2'b00;
    parameter RIGHT = 2'b01;
    parameter FALLING = 2'b10;
    parameter DIGGING = 2'b11;
    
    reg [1:0] state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            LEFT: begin
                if (~ground) 
                    next_state = FALLING;
                else if (dig)
                    next_state = DIGGING;
                else if (bump_left)
                    next_state = RIGHT;
                else
                    next_state = LEFT;
            end
            RIGHT: begin
                if (~ground)
                    next_state = FALLING;
                else if (dig)
                    next_state = DIGGING;
                else if (bump_right)
                    next_state = LEFT;
                else
                    next_state = RIGHT;
            end
            FALLING: begin
                if (ground)
                    next_state = state[0] ? RIGHT : LEFT; // Restore previous direction
                else
                    next_state = FALLING;
            end
            DIGGING: begin
                if (~ground)
                    next_state = FALLING;
                else
                    next_state = DIGGING;
            end
            default: next_state = LEFT;
        endcase
    end

    // State register
    always @(posedge clk, posedge areset) begin
        if (areset)
            state <= LEFT;
        else
            state <= next_state;
    end

    // Output logic
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah = (state == FALLING);
    assign digging = (state == DIGGING);

endmodule