module TopModule(
    input x,
    input y,
    output z
);
    // Optimized implementation: z = (x & ~y) ^ ~(x ^ y) simplifies to x | ~y
    // This requires only 1 OR gate and 1 NOT gate
    assign z = x | ~y;
endmodule