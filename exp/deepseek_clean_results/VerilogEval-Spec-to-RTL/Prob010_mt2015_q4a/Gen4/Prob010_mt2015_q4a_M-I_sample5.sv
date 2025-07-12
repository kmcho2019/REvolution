module TopModule (
    input x,
    input y,
    output z
);
    assign z = x & ~y;  // Equivalent to (x^y) & x, but more efficient
endmodule