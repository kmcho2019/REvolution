module TopModule (
    input in1,
    input in2,
    output out
);
    wire not_in1, not_in2;
    
    // Invert inputs using NAND gates (universal gate implementation)
    nand(not_in1, in1, in1);
    nand(not_in2, in2, in2);
    
    // NOR implementation using De Morgan's: ~(A|B) = ~A & ~B = ~(~A NAND ~B)
    nand(out, not_in1, not_in2);
endmodule