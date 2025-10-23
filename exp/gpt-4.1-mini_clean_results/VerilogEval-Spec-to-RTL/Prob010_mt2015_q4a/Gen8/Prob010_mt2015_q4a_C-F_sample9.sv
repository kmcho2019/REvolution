module TopModule (
    input  x,
    input  y,
    output z
);
    // Implement the exact specified function: z = (x ^ y) & x
    // Note: This is logically equivalent to z = x & ~y, which can be used for power/area optimization.
    assign z = (x ^ y) & x;
endmodule