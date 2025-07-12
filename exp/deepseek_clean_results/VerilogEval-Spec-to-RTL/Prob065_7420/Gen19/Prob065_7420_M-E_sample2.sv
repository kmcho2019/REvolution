module TopModule #(
    parameter WIDTH = 1  // Default to 1-bit, but parameterizable
) (
    input  [WIDTH-1:0] p1a, p1b, p1c, p1d,
    input  [WIDTH-1:0] p2a, p2b, p2c, p2d,
    output [WIDTH-1:0] p1y, p2y
);

    // First 4-input NAND gate using parallel bitwise operations
    assign p1y = ~(& {p1a, p1b, p1c, p1d});

    // Second 4-input NAND gate using parallel bitwise operations
    assign p2y = ~(& {p2a, p2b, p2c, p2d});

endmodule