module TopModule(
    input a,
    input b,
    output out
);
    wire nand_ab;
    wire nand_a_a;
    wire nand_b_b;
    wire nand_nand_a_b;

    // NAND gate: ~(a & b)
    assign nand_ab = ~(a & b);
    assign nand_a_a = ~(a & a);  // NOT a
    assign nand_b_b = ~(b & b);  // NOT b
    assign nand_nand_a_b = ~(nand_a_a & nand_b_b);
    assign out = ~(nand_ab & nand_nand_a_b);
endmodule