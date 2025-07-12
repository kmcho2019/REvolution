module nand2 (
    input  a,
    input  b,
    output y
);
    assign y = ~(a & b);
endmodule

module nand4_from_nand2(
    input  a,
    input  b,
    input  c,
    input  d,
    output y
);
    wire n1, n2;

    // First stage: two 2-input NAND gates each covering half inputs
    nand2 nand_stage1_a (.a(a), .b(b), .y(n1));
    nand2 nand_stage1_b (.a(c), .b(d), .y(n2));

    // Second stage: NAND the outputs of first stage to form 4-input NAND
    nand2 nand_stage2 (.a(n1), .b(n2), .y(y));
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

// Instantiate two 4-input NAND gates built from 2-input NAND primitives
nand4_from_nand2 nand_gate1 (
    .a(p1a),
    .b(p1b),
    .c(p1c),
    .d(p1d),
    .y(p1y)
);

nand4_from_nand2 nand_gate2 (
    .a(p2a),
    .b(p2b),
    .c(p2c),
    .d(p2d),
    .y(p2y)
);

endmodule