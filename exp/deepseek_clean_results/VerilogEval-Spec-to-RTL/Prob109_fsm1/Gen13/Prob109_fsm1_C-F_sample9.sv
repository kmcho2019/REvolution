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
    
    // Optimized next state logic:
    // state ^ ~in gives the correct transition:
    // A(0) + 0->B(1): 0 ^ 1 = 1
    // A(0) + 1->A(0): 0 ^ 0 = 0
    // B(1) + 0->A(0): 1 ^ 1 = 0
    // B(1) + 1->B(1): 1 ^ 0 = 1
    wire next_state = areset ? B : state ^ ~in;
    
    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end
    
    // Output is simply the state bit (B=1, A=0)
    assign out = state;
    
endmodule