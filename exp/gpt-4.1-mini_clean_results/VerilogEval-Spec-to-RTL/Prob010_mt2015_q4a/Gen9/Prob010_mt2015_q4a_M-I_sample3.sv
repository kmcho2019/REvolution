module TopModule (
    input  x,
    input  y,
    output z
);
    // Implement z = (x ^ y) & x using the logically equivalent simplified expression:
    // (x ^ y) & x = x & ~y
    assign z = x & ~y;
endmodule