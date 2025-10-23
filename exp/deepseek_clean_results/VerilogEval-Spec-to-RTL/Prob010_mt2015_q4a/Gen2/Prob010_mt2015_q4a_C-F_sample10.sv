module TopModule (
    input x,
    input y,
    output z
);
    // Implementation of z = (x^y) & x optimized to x & ~y
    assign z = x & ~y;
endmodule