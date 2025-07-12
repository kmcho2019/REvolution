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
    
    // State register update with optimized next state logic
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= state ^ ~in;  // Equivalent to the state transition rules
    end
    
    // Output logic
    assign out = state;  // Since B=1 and A=0
    
endmodule