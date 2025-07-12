module TopModule (
    input in1,
    input in2,
    output out
);
    wire nand_out;
    
    // Implement NOR using NAND gates: NOR(a,b) = NAND(NOT(a), NOT(b)) = NAND(NAND(a,a), NAND(b,b))
    nand(nand_out, in1, in2);
    nand(out, nand_out, nand_out);
endmodule