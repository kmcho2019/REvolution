module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State definitions
    parameter A = 1'b0;
    parameter B = 1'b1;
    
    reg state;
    
    // Next state logic - simplified direct equation
    wire next_state = (state == A) ? in : ~in;
    
    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end
    
    // Output logic - output is 1 when in state B
    assign out = state;
    
endmodule