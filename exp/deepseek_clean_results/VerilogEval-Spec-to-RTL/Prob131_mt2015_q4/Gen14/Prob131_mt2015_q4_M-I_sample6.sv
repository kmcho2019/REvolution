module TopModule(
    input x,
    input y,
    output z
);
    // Optimized implementation - entire function simplifies to ~y
    assign z = ~y;
endmodule