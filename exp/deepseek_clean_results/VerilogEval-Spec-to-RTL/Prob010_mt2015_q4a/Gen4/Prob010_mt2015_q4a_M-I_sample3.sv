module TopModule (
    input x,
    input y,
    output z
);
    // Optimal implementation of z = (x^y) & x
    // Mathematically equivalent to x & ~y (1 gate operation)
    // This is the minimal possible implementation for this function
    assign z = x & ~y;
endmodule