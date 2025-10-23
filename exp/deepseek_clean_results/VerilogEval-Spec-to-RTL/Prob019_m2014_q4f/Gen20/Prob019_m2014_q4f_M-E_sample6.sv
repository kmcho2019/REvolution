module TopModule (
    input in1,
    input in2,
    output out
);
    // LUT-based implementation of AND with inverted in2
    // Truth table for (in1 AND NOT in2):
    // in1 in2 | out
    //  0   0  | 0
    //  0   1  | 0
    //  1   0  | 1
    //  1   1  | 0
    
    reg [3:0] lut = 4'b0010; // Pre-programmed LUT
    
    assign out = lut[{in1, in2}];
    
    /* Configuration options (commented out):
    // To change logic function, modify LUT value:
    // AND:       4'b0001
    // OR:        4'b0111
    // XOR:       4'b0110
    // NAND:      4'b1110
    // NOR:       4'b1000
    */
endmodule