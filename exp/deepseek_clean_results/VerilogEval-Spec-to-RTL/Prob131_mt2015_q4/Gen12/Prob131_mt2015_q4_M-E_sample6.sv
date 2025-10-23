module TopModule(
    input x,
    input y,
    output z
);
    // Direct implementation of optimized boolean equation
    // After simplification: z = (x^y & x) | ~(x^y)) ^ ((x^y & x) & ~(x^y))
    // Which reduces to: z = x & ~y
    assign z = x & ~y;
endmodule