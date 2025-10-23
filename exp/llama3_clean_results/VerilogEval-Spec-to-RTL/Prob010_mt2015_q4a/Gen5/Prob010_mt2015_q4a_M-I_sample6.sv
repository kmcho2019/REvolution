module TopModule(
    input x,
    input y,
    output z
);

// The original implementation is already optimized for area and functionality.
// No further simplification or optimization is possible without changing the logic.
assign z = x & (~y);

endmodule