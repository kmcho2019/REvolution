module TopModule (
    input  x,
    input  y,
    output z
);
    // Implementing the specified function: z = (x ^ y) & x
    // This expression is logically equivalent to the simpler form:
    // z = x & ~y
    // Using the simplified form reduces power and area by replacing
    // the XOR gate with a NOT gate, which has lower switching activity and gate count.
    assign z = x & ~y;
endmodule