module TopModule(input in1, input in2, output out);
    wire not_in1, not_in2;
    wire nand_out;
    
    // Invert inputs using NAND gates
    nand(not_in1, in1, in1);
    nand(not_in2, in2, in2);
    
    // Combine inverted inputs with NAND
    nand(nand_out, not_in1, not_in2);
    
    // Final inversion to get NOR
    nand(out, nand_out, nand_out);
endmodule