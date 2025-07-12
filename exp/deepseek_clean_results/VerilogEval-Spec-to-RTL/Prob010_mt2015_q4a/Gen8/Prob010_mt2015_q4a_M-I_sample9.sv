module TopModule (
    input x,
    input y,
    output z
);
    // Optimized implementation: z = x & ~y
    assign z = x & ~y;
endmodule