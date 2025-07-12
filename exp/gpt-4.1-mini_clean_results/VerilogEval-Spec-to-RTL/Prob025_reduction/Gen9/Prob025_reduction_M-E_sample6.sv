module TopModule (
    input  [7:0] in,
    output       parity
);

    wire [3:0] xor_stage1;
    wire [1:0] xor_stage2;
    wire       xor_stage3;

    // Level 1: XOR pairs of bits
    assign xor_stage1[0] = in[0] ^ in[1];
    assign xor_stage1[1] = in[2] ^ in[3];
    assign xor_stage1[2] = in[4] ^ in[5];
    assign xor_stage1[3] = in[6] ^ in[7];

    // Level 2: XOR results of previous stage
    assign xor_stage2[0] = xor_stage1[0] ^ xor_stage1[1];
    assign xor_stage2[1] = xor_stage1[2] ^ xor_stage1[3];

    // Level 3: Final XOR to produce parity
    assign xor_stage3 = xor_stage2[0] ^ xor_stage2[1];

    // Output parity
    assign parity = xor_stage3;

endmodule