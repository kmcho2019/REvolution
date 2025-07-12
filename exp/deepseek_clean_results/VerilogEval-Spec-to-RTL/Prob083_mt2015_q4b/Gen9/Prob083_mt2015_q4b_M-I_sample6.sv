module TopModule (
    input x,
    input y,
    output z
);
    // Truth table:
    // x y | z
    // 0 0 | 1
    // 0 1 | 0
    // 1 0 | 0
    // 1 1 | 1
    // Optimized for power using AND-OR implementation
    assign z = (x & y) | (~x & ~y);
endmodule