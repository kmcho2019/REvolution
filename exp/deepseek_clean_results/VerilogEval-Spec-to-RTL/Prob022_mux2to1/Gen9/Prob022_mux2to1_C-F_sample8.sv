module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    // Direct implementation of mux logic using continuous assignment
    // Combines the best of both approaches:
    // - Clear Boolean expression like Example 2
    // - Explicit gate-level structure like Example 1
    assign out = (a & ~sel) | (b & sel);
endmodule