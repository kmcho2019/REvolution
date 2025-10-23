module FourInputNAND (
    input a, b, c, d,
    output y
);
    // Structural implementation using 2-input NAND gates for better PPA
    wire nand_ab, nand_cd;
    
    assign nand_ab = ~(a & b);
    assign nand_cd = ~(c & d);
    assign y = ~(nand_ab & nand_cd);
endmodule

module TopModule (
    input p1a, p1b, p1c, p1d,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);
    // First 4-input NAND gate
    FourInputNAND gate1 (
        .a(p1a),
        .b(p1b),
        .c(p1c),
        .d(p1d),
        .y(p1y)
    );

    // Second 4-input NAND gate
    FourInputNAND gate2 (
        .a(p2a),
        .b(p2b),
        .c(p2c),
        .d(p2d),
        .y(p2y)
    );
endmodule