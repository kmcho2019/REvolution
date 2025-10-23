module TopModule(
    input x,
    input y,
    output z
);
    // ModuleA logic: z = (x^y) & x
    wire a_out = (x ^ y) & x;
    
    // ModuleB logic: z = ~(x ^ y)
    wire b_out = ~(x ^ y);
    
    // Final optimized output
    assign z = a_out ^ b_out;
endmodule