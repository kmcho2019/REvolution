module TopModule (
    input in1,
    input in2,
    output out
);
    // Implement NOR using only NAND gates (universal gate demonstration)
    wire not_in1, not_in2;
    
    // First NAND acts as inverter for in1
    nand(not_in1, in1, in1);
    
    // Second NAND acts as inverter for in2
    nand(not_in2, in2, in2);
    
    // Third NAND combines inverted inputs to produce NOR
    nand(out, not_in1, not_in2);
endmodule