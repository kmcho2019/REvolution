module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    wire nand_ab;
    wire nand_a_nand_ab;
    wire nand_b_nand_ab;
    
    // NAND of inputs
    nand (nand_ab, a, b);
    
    // NAND of a and nand_ab: corresponds to a AND b
    nand (nand_a_nand_ab, a, nand_ab);
    
    // NAND of b and nand_ab: corresponds to b AND a
    nand (nand_b_nand_ab, b, nand_ab);
    
    // NAND of previous two results gives XNOR output
    nand (out, nand_a_nand_ab, nand_b_nand_ab);
endmodule