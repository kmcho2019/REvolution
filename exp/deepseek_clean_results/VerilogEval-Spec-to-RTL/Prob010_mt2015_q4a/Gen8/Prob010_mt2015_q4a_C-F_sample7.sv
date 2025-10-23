module TopModule (
    input x,
    input y,
    output z
);
    // Equivalent to (x^y) & x, optimized as x & ~y
    // Maintains mux-like structure for potential implementation benefits
    assign z = x & ~y;
endmodule