module TopModule (
    input  x,
    input  y,
    output z
);
    // Implement z as x & ~y, which is logically equivalent to (x ^ y) & x
    assign z = x & ~y;
endmodule