module TopModule (
    input x,
    input y,
    output z
);
    assign z = x & ~y;  // Optimal implementation of z = (x^y) & x
endmodule