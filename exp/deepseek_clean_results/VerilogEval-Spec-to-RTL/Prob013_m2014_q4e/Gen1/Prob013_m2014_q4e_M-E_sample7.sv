module TopModule (
    input in1,
    input in2,
    output out
);
    wire not_in1, not_in2;
    
    // Implement NOT using NAND (NAND(a,a) = NOT(a))
    nand(not_in1, in1, in1);
    nand(not_in2, in2, in2);
    
    // Implement NOR using NAND of the inverted inputs
    nand(out, not_in1, not_in2);
endmodule