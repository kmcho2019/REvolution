module TopModule (
    input in1,
    input in2,
    output out
);
    wire not_in1, not_in2, or_term;
    
    // First NAND gate acts as NOT for in1 (NAND with both inputs tied together)
    nand(not_in1, in1, in1);
    
    // Second NAND gate acts as NOT for in2
    nand(not_in2, in2, in2);
    
    // Third NAND gate performs OR operation (De Morgan's: NOT(NOT A AND NOT B) = A OR B)
    // Then inverts it to get NOR
    nand(out, not_in1, not_in2);
endmodule