module TopModule(
    input x,
    input y,
    output z
);
    // Simplified logic:
    // Original: z = ((A1 | B1) ^ (A2 & B2))
    // Where A = (x ^ y) & x, B = ~(x ^ y)
    // After simplification:
    assign z = x & ~y;
endmodule