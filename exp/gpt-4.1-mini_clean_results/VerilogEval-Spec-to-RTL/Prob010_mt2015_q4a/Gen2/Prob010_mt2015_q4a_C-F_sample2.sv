module TopModule (
    input  x,
    input  y,
    output z
);

    // Original function: z = (x ^ y) & x
    // Simplified to:     z = x & ~y
    // This simplification is logically equivalent for all input combinations.

    assign z = x & ~y;

endmodule