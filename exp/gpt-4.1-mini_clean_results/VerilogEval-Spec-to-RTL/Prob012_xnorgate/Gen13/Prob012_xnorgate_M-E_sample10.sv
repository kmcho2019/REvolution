module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    wire nand_ab;
    wire or_ab;
    wire nand_nor;
    
    // NAND gate: nand_ab = ~(a & b)
    assign nand_ab = ~(a & b);
    
    // OR gate: or_ab = a | b
    assign or_ab = a | b;
    
    // NAND gate: nand_nor = ~(nand_ab & or_ab)
    // nand_nor = ~((~(a & b)) & (a | b)) = XOR(a,b)
    assign nand_nor = ~(nand_ab & or_ab);
    
    // XNOR is the inversion of XOR
    assign out = ~nand_nor;
endmodule