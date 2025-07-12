module TopModule (
    input  x,
    input  y,
    output z
);
    // The function z = (x ^ y) & x simplifies logically to z = x & ~y.
    // Implementing the simplified form reduces gate count and power without changing functionality.
    assign z = x & ~y;
endmodule