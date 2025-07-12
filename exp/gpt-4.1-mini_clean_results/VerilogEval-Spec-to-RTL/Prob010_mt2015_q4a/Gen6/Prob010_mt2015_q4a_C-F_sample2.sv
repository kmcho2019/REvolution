module TopModule (
    input  x,
    input  y,
    output z
);
    // Implementing as per specification: z = (x ^ y) & x
    // Note: This is logically equivalent to z = x & ~y, but we keep explicit XOR and AND for clarity.
    assign z = (x ^ y) & x;
endmodule