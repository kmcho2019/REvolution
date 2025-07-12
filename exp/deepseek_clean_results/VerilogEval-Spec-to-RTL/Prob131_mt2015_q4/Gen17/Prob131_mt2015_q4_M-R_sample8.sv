module TopModule(
    input x,
    input y,
    output z
);
    // Direct implementation of ModuleA logic: z = x & ~y
    wire a_out = x & ~y;
    
    // Direct implementation of ModuleB logic: z = ~(x ^ y)
    wire b_out = ~(x ^ y);
    
    // Final output logic: (a_out OR b_out) XOR (a_out AND b_out)
    // Which simplifies to a_out XOR b_out
    assign z = a_out ^ b_out;
endmodule