module TopModule(
    input x,
    input y,
    output z
);
    // Implement ModuleA logic directly: z = x & ~y
    wire a_out = x & ~y;
    
    // Implement ModuleB logic directly: z = ~(x ^ y)
    wire b_out = ~(x ^ y);
    
    // Final optimized output - equivalent to (a_out|b_out)^(a_out&b_out)
    assign z = a_out ^ b_out;
endmodule