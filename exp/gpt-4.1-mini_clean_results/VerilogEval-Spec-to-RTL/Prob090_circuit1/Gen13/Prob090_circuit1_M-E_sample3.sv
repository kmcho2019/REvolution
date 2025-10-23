module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    wire nand_ab;

    // First NAND gate: nand_ab = ~(a & b)
    nand u1 (nand_ab, a, b);

    // Second NAND gate: q = ~(nand_ab & nand_ab) = nand_ab inverted = a & b
    nand u2 (q, nand_ab, nand_ab);
endmodule