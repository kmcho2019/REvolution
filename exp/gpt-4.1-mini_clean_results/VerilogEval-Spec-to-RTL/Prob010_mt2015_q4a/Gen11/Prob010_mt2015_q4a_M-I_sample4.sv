module TopModule (
    input  x,
    input  y,
    output z
);
    // Optimized implementation using logical equivalence:
    // (x ^ y) & x  ==  x & ~y
    // This reduces gate count and switching activity for better power and area efficiency.
    assign z = x & ~y;
endmodule