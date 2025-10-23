module TopModule(
    input a,
    input b,
    output q
);
    wire nand_ab;
    // First NAND gate
    assign nand_ab = ~(a & b);
    // Second NAND gate acting as inverter
    assign q = ~(nand_ab & nand_ab);
endmodule