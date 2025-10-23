module TopModule (
    input x,
    input y,
    output z
);
    // z = (x^y) & x = x & ~y
    assign z = x & ~y;
endmodule