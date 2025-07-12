module TopModule (
    input x,
    input y,
    output z
);
    // Optimal implementation: z = x & ~y (equivalent to (x^y) & x)
    assign z = x & ~y;
endmodule