module TopModule(
    input  a,
    input  b,
    input  sel,
    output reg out
);
    
    // Implement the multiplexer using an always block with conditional logic
    always @(*) begin
        // Create the inverse of sel
        reg not_sel;
        not_sel = ~sel;

        // Conditional paths for a and b based on sel
        reg cond_a;
        cond_a = a & not_sel;
        
        reg cond_b;
        cond_b = b & sel;

        // Final output is the OR of the conditional paths
        out = cond_a | cond_b;
    end
    
endmodule