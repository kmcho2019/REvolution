module TopModule(
    input  [3:0] in,
    output [3:1] out_both,
    output [2:0] out_any,
    output [3:0] out_different
);

    // out_both: current bit and its neighbour to the left are both '1'
    assign out_both[3:1] = in[3:1] & {in[3:0][2:1]};  // Using bit slicing to shift left by one bit
    
    // out_any: current bit or its neighbour to the right is '1'
    assign out_any[2:0] = in[2:0] | {in[2:0][1:0], in[3]};  // Using bit slicing to shift right by one bit and wrapping around
    
    // out_different: current bit is different from its neighbour to the left
    assign out_different[3] = in[3] ^ in[0];  // Most significant bit with least significant bit
    assign out_different[2:0] = in[2:0] ^ in[3:1];  // Other bits with their left neighbour

endmodule