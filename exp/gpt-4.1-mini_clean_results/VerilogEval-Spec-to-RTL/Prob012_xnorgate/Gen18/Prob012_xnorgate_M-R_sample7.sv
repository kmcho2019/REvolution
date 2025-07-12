module TopModule(
    input a,
    input b,
    output out
);
    wire nand_ab = ~(a & b);
    wire nand_a_a = ~(a & a);  // ~a
    wire nand_b_b = ~(b & b);  // ~b
    wire nand_nand_a_b = ~(nand_a_a & nand_b_b);
    assign out = ~(nand_ab & nand_nand_a_b);
endmodule