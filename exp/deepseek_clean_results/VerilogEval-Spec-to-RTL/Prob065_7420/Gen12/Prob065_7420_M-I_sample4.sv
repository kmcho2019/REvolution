module FourInputNAND (
    input a, b, c, d,
    output y
);
    // Structural implementation using 2-input NAND gates
    wire nand_ab, nand_cd;
    
    // First level NANDs
    nand U1 (nand_ab, a, b);
    nand U2 (nand_cd, c, d);
    
    // Final NAND
    nand U3 (y, nand_ab, nand_cd);
endmodule

module TopModule (
    input p1a, p1b, p1c, p1d,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);
    // Instantiate first 4-input NAND gate
    FourInputNAND gate1 (
        .a(p1a),
        .b(p1b),
        .c(p1c),
        .d(p1d),
        .y(p1y)
    );

    // Instantiate second 4-input NAND gate
    FourInputNAND gate2 (
        .a(p2a),
        .b(p2b),
        .c(p2c),
        .d(p2d),
        .y(p2y)
    );
endmodule