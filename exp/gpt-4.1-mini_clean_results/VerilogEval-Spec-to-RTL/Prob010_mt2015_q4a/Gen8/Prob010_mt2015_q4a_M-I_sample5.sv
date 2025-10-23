module TopModule (
    input  x,
    input  y,
    output z
);
    // Direct use of built-in XOR operator and AND
    assign z = (x ^ y) & x;
endmodule