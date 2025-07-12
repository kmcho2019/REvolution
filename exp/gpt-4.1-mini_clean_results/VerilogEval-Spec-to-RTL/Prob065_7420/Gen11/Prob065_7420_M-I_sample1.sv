module nand4_dual (
    input  a1,
    input  b1,
    input  c1,
    input  d1,
    input  a2,
    input  b2,
    input  c2,
    input  d2,
    output y1,
    output y2
);
    // Implement two 4-input NAND gates with continuous assignments
    assign y1 = ~(a1 & b1 & c1 & d1);
    assign y2 = ~(a2 & b2 & c2 & d2);
endmodule

module TopModule(
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,
    output p2y
);

    // Instantiate one dual 4-input NAND gate module
    nand4_dual u_dual (
        .a1(p1a),
        .b1(p1b),
        .c1(p1c),
        .d1(p1d),
        .a2(p2a),
        .b2(p2b),
        .c2(p2c),
        .d2(p2d),
        .y1(p1y),
        .y2(p2y)
    );

endmodule