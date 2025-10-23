module TopModule(
    input x,
    input y,
    output z
);
    // Module A equivalent logic: z = x & ~y
    wire a_out = x & ~y;
    
    // Module B equivalent logic: z = ~(x ^ y)
    wire b_out = ~(x ^ y);
    
    // Final output: (a_out | b_out) ^ (a_out & b_out) simplifies to a_out ^ b_out
    assign z = a_out ^ b_out;
endmodule