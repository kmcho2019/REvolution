module TopModule (
    input a,
    input b,
    output out
);
    wire not_a, not_b;
    
    // Invert inputs using NAND gates (NAND with same input acts as inverter)
    nand(not_a, a, a);
    nand(not_b, b, b);
    
    // Implement AND using NAND followed by inverter
    wire nand_out;
    nand(nand_out, not_a, not_b);
    nand(out, nand_out, nand_out);
endmodule