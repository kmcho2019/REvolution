module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State definitions for readability
    parameter A = 1'b0;
    parameter B = 1'b1;
    
    reg state;
    
    // State register with optimized transition logic
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;         // Async reset to B
        else
            state <= state ^ ~in; // Efficient XOR transition logic
    end
    
    // Direct state-to-output mapping
    assign out = state;
    
endmodule