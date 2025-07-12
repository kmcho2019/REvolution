module TopModule (
    input [7:0] in,
    output parity
);
    // First stage: XOR groups of 4 bits
    wire stage1 = in[0] ^ in[1] ^ in[2] ^ in[3];
    wire stage2 = in[4] ^ in[5] ^ in[6] ^ in[7];
    
    // Final stage
    assign parity = stage1 ^ stage2;
endmodule