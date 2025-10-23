module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // Define states
    parameter LEFT = 1'b0;
    parameter RIGHT = 1'b1;
    
    reg state;
    reg next_state;
    
    // State transition logic
    always @(*) begin
        case (state)
            LEFT: next_state = bump_left ? RIGHT : LEFT;
            RIGHT: next_state = bump_right ? LEFT : RIGHT;
            default: next_state = LEFT;
        endcase
    end
    
    // State register with asynchronous reset
    always @(posedge clk, posedge areset) begin
        if (areset)
            state <= LEFT;
        else
            state <= next_state;
    end
    
    // Output logic (Moore machine)
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);

endmodule