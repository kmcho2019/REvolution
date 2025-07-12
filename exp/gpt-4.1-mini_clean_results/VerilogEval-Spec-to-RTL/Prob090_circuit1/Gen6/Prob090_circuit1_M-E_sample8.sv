module TopModule (
    input  a,
    input  b,
    output q
);
    wire nand_ab;
    wire not_nand_ab;

    // First NAND gate: output is ~(a & b)
    nand u1(nand_ab, a, b);
    // Inverter implemented as NAND with tied inputs: q = ~(nand_ab & nand_ab) = nand_ab'
    nand u2(not_nand_ab, nand_ab, nand_ab);
    assign q = not_nand_ab;
endmodule