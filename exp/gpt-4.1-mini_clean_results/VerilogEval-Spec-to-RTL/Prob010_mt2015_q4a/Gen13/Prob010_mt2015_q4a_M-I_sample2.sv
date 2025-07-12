module TopModule (
    input  x,
    input  y,
    output z
);
    // Direct continuous assignment for z = (x ^ y) & x
    assign z = (x ^ y) & x;
endmodule