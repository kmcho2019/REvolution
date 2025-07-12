module TopModule (
    input a,
    input b,
    output out
);
    // XNOR implementation using only NAND gates
    wire a_nand_b;
    wire a_nand_anb;
    wire b_nand_anb;
    
    assign a_nand_b = ~(a & b);
    assign a_nand_anb = ~(a & a_nand_b);
    assign b_nand_anb = ~(b & a_nand_b);
    assign out = ~(a_nand_anb & b_nand_anb);
endmodule