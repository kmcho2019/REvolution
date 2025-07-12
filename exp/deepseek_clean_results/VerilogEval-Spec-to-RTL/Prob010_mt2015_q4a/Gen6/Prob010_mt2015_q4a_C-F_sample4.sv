module TopModule (
    input x,
    input y,
    output z
);
    // Optimal implementation of z = (x^y) & x
    // Using boolean identity: (x^y) & x = x & ~y
    // This represents:
    // - Minimal gate count (1 AND with inverted input)
    // - Perfect timing (single gate delay)
    // - Lowest possible power and area
    assign z = x & ~y;
endmodule