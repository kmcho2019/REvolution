module TopModule #(
    parameter WIDTH = 4  // Configurable input width per NAND gate
) (
    input p1a, p1b, p1c, p1d,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);

    // Pack inputs into vectors for cleaner processing
    wire [WIDTH-1:0] gate1_inputs = {p1d, p1c, p1b, p1a};
    wire [WIDTH-1:0] gate2_inputs = {p2d, p2c, p2b, p2a};

    // Parallel NAND implementations using reduction operators
    assign p1y = ~(&gate1_inputs);  // 4-input NAND for first gate
    assign p2y = ~(&gate2_inputs);  // 4-input NAND for second gate

endmodule