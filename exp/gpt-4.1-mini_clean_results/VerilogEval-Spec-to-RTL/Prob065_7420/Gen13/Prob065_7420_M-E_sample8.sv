// Basic 2-input NAND gate module
module nand2(
    input a,
    input b,
    output y
);
    assign y = ~(a & b);
endmodule

// 4-input NAND gate built from 2-input NAND gates
module nand4_from_nand2(
    input a,
    input b,
    input c,
    input d,
    output y
);
    wire n1, n2;
    // First stage: nand of a & b, and nand of c & d
    nand2 u1(.a(a), .b(b), .y(n1));
    nand2 u2(.a(c), .b(d), .y(n2));
    // Second stage: nand of the two intermediate results (note: to get NAND of all 4 inputs,
    // we nand the outputs of two NAND gates which is equivalent to NAND4)
    nand2 u3(.a(n1), .b(n2), .y(y));
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
    // Instantiate two 4-input NAND gates built from 2-input NAND gates
    nand4_from_nand2 u_p1 (
        .a(p1a),
        .b(p1b),
        .c(p1c),
        .d(p1d),
        .y(p1y)
    );

    nand4_from_nand2 u_p2 (
        .a(p2a),
        .b(p2b),
        .c(p2c),
        .d(p2d),
        .y(p2y)
    );
endmodule