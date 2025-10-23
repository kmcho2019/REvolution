module TopModule (
    input  x,
    input  y,
    output z
);
    // Implementing z = (x ^ y) & x directly, 
    // which is logically equivalent to z = x & ~y.
    assign z = (x ^ y) & x;
endmodule