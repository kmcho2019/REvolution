// 4-input NAND gate module (reusable component)
module NAND4 (
    input wire a, b, c, d,  // Explicit wire declaration
    output wire y
);
    // Efficient 4-input NAND using reduction operator
    assign y = ~& {a, b, c, d};
endmodule

// Top module implementing 7420 chip functionality
module TopModule (
    input wire p1a, p1b, p1c, p1d,  // Group related signals
    input wire p2a, p2b, p2c, p2d,
    output wire p1y, p2y
);
    // First 4-input NAND gate instance
    NAND4 nand_gate1 (
        .a(p1a),
        .b(p1b),
        .c(p1c),
        .d(p1d),
        .y(p1y)
    );

    // Second 4-input NAND gate instance
    NAND4 nand_gate2 (
        .a(p2a),
        .b(p2b),
        .c(p2c),
        .d(p2d),
        .y(p2y)
    );
endmodule