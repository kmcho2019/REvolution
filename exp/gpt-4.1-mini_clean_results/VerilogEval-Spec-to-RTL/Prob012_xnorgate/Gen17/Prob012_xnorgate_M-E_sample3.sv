module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    wire nand_ab;
    wire nand_a_nand_ab;
    wire nand_b_nand_ab;

    // NAND gate instances implementing XNOR:
    // XNOR = (a NAND (a NAND b)) NAND (b NAND (a NAND b))
    assign nand_ab = ~(a & b);               // NAND of a and b
    assign nand_a_nand_ab = ~(a & nand_ab);  // NAND of a and nand_ab
    assign nand_b_nand_ab = ~(b & nand_ab);  // NAND of b and nand_ab
    assign out = ~(nand_a_nand_ab & nand_b_nand_ab); // NAND final output

endmodule