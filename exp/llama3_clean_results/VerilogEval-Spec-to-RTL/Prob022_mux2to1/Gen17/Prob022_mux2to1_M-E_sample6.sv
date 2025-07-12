module TopModule(
    input  a,
    input  b,
    input  sel,
    output out
);
    
    // Create the inverse of sel
    wire not_sel;
    assign not_sel = ~sel;

    // Conditional paths for a and b based on sel
    wire cond_a;
    assign cond_a = a & not_sel;
    
    wire cond_b;
    assign cond_b = b & sel;

    // Final output is the OR of the conditional paths
    assign out = cond_a | cond_b;
    
endmodule