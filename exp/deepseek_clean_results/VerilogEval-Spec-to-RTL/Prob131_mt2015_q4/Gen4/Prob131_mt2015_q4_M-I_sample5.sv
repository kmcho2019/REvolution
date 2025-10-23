module TopModule(
    input x,
    input y,
    output z
);
    // Module A logic: z = (x ^ y) & x
    wire a_out = (x ^ y) & x;
    
    // Module B logic: z = ~x & ~y | x & y
    wire b_out = (~x & ~y) | (x & y);
    
    // Optimized final logic:
    // Original: z = (a_out | b_out) ^ (a_out & b_out)
    // Boolean simplification:
    // (A+B)^(A&B) = A^B
    assign z = a_out ^ b_out;
endmodule