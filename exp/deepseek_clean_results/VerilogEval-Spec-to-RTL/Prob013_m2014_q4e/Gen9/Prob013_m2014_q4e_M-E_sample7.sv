module TopModule (
    input in1,
    input in2,
    output out
);
    wire not_in1, not_in2;
    wire nand_out;
    
    // First stage: invert inputs using NAND gates
    nand NAND1(not_in1, in1, in1);
    nand NAND2(not_in2, in2, in2);
    
    // Second stage: NAND the inverted inputs (equivalent to OR)
    nand NAND3(nand_out, not_in1, not_in2);
    
    // Final stage: invert the NAND output to get NOR
    nand NAND4(out, nand_out, nand_out);
endmodule