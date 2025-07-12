module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State encoding
    parameter LEFT = 1'b0;
    parameter RIGHT = 1'b1;
    
    reg state;
    
    // Next state logic using continuous assignment
    wire next_state = (state == LEFT) ? 
                     (bump_left ? RIGHT : LEFT) : 
                     (bump_right ? LEFT : RIGHT);
    
    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= LEFT;
        else
            state <= next_state;
    end
    
    // Output assignments
    assign walk_left = ~state;  // LEFT when state is 0
    assign walk_right = state;  // RIGHT when state is 1

endmodule