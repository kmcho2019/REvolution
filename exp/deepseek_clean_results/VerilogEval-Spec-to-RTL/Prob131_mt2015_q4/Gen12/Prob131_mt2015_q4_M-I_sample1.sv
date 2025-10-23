module TopModule(
    input x,
    input y,
    output z
);
    // Optimized implementation:
    // Original: z = (x&~y) ^ (x==y)
    // Simplified: z = x&y
    assign z = x & y;
endmodule