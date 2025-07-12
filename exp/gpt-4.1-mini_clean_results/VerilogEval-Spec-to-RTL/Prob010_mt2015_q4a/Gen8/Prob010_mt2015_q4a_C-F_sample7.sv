module TopModule (
    input  x,
    input  y,
    output z
);
    // Implementing the specified function: z = (x ^ y) & x
    // Note: This is logically equivalent to z = x & ~y,
    // which can reduce power and area by replacing XOR with NOT.
    assign z = (x ^ y) & x;
endmodule