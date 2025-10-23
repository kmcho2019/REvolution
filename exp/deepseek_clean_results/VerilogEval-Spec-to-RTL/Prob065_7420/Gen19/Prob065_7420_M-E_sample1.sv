module Decomposed4NAND (
    input a,
    input b,
    input c,
    input d,
    output y
);
    wire nand_ab, nand_cd;
    
    // First level: Two 2-input NANDs
    assign nand_ab = ~(a & b);
    assign nand_cd = ~(c & d);
    
    // Second level: AND of NAND results (equivalent to 4-input NAND)
    assign y = ~(nand_ab & nand_cd);
endmodule

module TopModule (
    input p1a,
    input p1b,
    input p1c,
    input p1d,
    input p2a,
    input p2b,
    input p2c,
    input p2d,
    output p1y,
    output p2y
);

    // First 4-input NAND using decomposed structure
    Decomposed4NAND gate1 (
        .a(p1a),
        .b(p1b),
        .c(p1c),
        .d(p1d),
        .y(p1y)
    );

    // Second 4-input NAND using decomposed structure
    Decomposed4NAND gate2 (
        .a(p2a),
        .b(p2b),
        .c(p2c),
        .d(p2d),
        .y(p2y)
    );

endmodule