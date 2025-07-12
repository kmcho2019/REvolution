module TreeNAND4 (
    input a,
    input b,
    input c,
    input d,
    output y
);
    wire nand_ab, nand_cd;
    
    // First level: NAND pairs of inputs
    assign nand_ab = ~(a & b);
    assign nand_cd = ~(c & d);
    
    // Second level: NAND the intermediate results
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

    // First 4-input NAND gate using tree structure
    TreeNAND4 nand1 (
        .a(p1a),
        .b(p1b),
        .c(p1c),
        .d(p1d),
        .y(p1y)
    );

    // Second 4-input NAND gate using tree structure
    TreeNAND4 nand2 (
        .a(p2a),
        .b(p2b),
        .c(p2c),
        .d(p2d),
        .y(p2y)
    );

endmodule