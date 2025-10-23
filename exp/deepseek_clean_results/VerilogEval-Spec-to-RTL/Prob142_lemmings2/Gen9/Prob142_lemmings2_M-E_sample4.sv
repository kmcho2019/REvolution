module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

    // State encoding
    parameter LEFT  = 2'b00;
    parameter RIGHT = 2'b01;
    parameter FALL  = 2'b10;
    
    reg [1:0] state, next_state;

    // Next state logic with fall buffer
    always @(*) begin
        case (state)
            LEFT: begin
                if (!ground)
                    next_state = FALL;
                else if (bump_left)
                    next_state = RIGHT;
                else
                    next_state = LEFT;
            end
            RIGHT: begin
                if (!ground)
                    next_state = FALL;
                else if (bump_right)
                    next_state = LEFT;
                else
                    next_state = RIGHT;
            end
            FALL: begin
                if (ground)
                    next_state = (state[0]) ? RIGHT : LEFT;  // Restore previous direction
                else
                    next_state = FALL;
            end
            default: next_state = LEFT;
        endcase
    end

    // State register with async reset
    always @(posedge clk, posedge areset) begin
        if (areset)
            state <= LEFT;
        else
            state <= next_state;
    end

    // Output logic - pure Moore
    assign walk_left  = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah       = (state == FALL);

endmodule