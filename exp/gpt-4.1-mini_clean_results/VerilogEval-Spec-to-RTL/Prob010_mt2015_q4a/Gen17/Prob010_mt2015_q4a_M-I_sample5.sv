module TopModule (
    input  x,
    input  y,
    output z
);
    // Direct continuous assignment implementing z = (x ^ y) & x
    assign z = (x ^ y) & x;
endmodule