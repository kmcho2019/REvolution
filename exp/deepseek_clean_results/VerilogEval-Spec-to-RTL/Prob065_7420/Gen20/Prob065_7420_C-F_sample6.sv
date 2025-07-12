module FourInputNAND (
    input a, b, c, d,
    output y
);
    // Efficient 4-input NAND implementation
    assign y = ~& {a, b, c, d};
endmodule

module TopModule (
    input p1a, p1b, p1c, p1d,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);
    // First NAND gate with explicit instance name
    FourInputNAND NAND1 (
        .a(p1a),
        .b(p1b),
        .c(p1c),
        .d(p1d),
        .y(p1y)
    );

    // Second NAND gate with explicit instance name
    FourInputNAND NAND2 (
        .a(p2a),
        .b(p2b),
        .c(p2c),
        .d(p2d),
        .y(p2y)
    );
endmodule