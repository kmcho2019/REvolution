module TopModule (
    input  x,
    input  y,
    output z
);
    // Implement optimized equivalent function: z = x & ~y
    // This is logically equivalent to z = (x ^ y) & x, but with fewer gates and lower power.
    assign z = x & ~y;
endmodule