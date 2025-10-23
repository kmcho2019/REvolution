module TopModule (
    input  [7:0] in,
    output       parity
);

    wire [3:0] xor_level1;
    wire [1:0] xor_level2;
    wire       xor_level3;

    // Level 1: XOR pairs of bits
    assign xor_level1[0] = in[0] ^ in[1];
    assign xor_level1[1] = in[2] ^ in[3];
    assign xor_level1[2] = in[4] ^ in[5];
    assign xor_level1[3] = in[6] ^ in[7];

    // Level 2: XOR pairs of previous results
    assign xor_level2[0] = xor_level1[0] ^ xor_level1[1];
    assign xor_level2[1] = xor_level1[2] ^ xor_level1[3];

    // Level 3: Final XOR for parity
    assign xor_level3 = xor_level2[0] ^ xor_level2[1];

    assign parity = xor_level3;

endmodule