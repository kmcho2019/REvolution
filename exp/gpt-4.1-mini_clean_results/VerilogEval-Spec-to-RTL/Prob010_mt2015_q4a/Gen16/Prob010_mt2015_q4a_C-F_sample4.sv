module TopModule (
    input  x,
    input  y,
    output z
);
    // Optimized boolean expression equivalent to (x ^ y) & x
    assign z = x & ~y;
endmodule