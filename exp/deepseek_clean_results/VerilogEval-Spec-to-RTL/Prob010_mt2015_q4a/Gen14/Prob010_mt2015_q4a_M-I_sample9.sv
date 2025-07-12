module TopModule (
    input x,
    input y,
    output z
);
    // Original specification: z = (x^y) & x
    // Logically equivalent to x & ~y
    assign z = (x ^ y) & x;
endmodule