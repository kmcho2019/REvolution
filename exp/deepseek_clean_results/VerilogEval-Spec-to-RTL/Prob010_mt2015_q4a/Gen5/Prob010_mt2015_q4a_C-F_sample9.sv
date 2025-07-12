module TopModule (
    input x,
    input y,
    output z
);
    // Implementation of z = (x^y) & x
    // Boolean simplification: (x^y) & x = x & ~y
    // This is the minimal 1-gate implementation with optimal PPA
    assign z = x & ~y;
endmodule