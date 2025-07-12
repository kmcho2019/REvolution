module TopModule (
    input x,
    input y,
    output z
);
    // Original function: z = (x^y) & x
    // Optimized to: z = x & ~y (since x^y = x&~y | ~x&y, and AND with x eliminates ~x term)
    assign z = x & ~y;
endmodule