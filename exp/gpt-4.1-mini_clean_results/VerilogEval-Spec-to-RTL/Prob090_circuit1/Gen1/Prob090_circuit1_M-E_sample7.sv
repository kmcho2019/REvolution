module TopModule (
    input  a,
    input  b,
    output q
);
    wire nand_ab;
    wire nand_inv;

    // First NAND gate: NAND of inputs a and b
    assign nand_ab = ~(a & b);

    // Second NAND gate: NAND of nand_ab with itself acts as an inverter
    assign q = ~(nand_ab & nand_ab);
endmodule