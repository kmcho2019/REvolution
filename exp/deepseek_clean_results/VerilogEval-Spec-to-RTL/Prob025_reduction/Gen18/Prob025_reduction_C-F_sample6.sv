module TopModule (
    input [7:0] in,
    output parity
);
    // First stage: XOR adjacent pairs
    wire [3:0] pair_xor = {
        in[6] ^ in[7],
        in[4] ^ in[5],
        in[2] ^ in[3],
        in[0] ^ in[1]
    };
    
    // Second stage: XOR the pair results
    wire [1:0] nibble_xor = {
        pair_xor[2] ^ pair_xor[3],
        pair_xor[0] ^ pair_xor[1]
    };
    
    // Final XOR
    assign parity = nibble_xor[0] ^ nibble_xor[1];
endmodule