module TopModule (
    input [7:0] in,
    output parity
);
    // First stage XORs (4 parallel)
    wire stage1_0 = in[0] ^ in[1];
    wire stage1_1 = in[2] ^ in[3];
    wire stage1_2 = in[4] ^ in[5];
    wire stage1_3 = in[6] ^ in[7];

    // Second stage XORs (2 parallel)
    wire stage2_0 = stage1_0 ^ stage1_1;
    wire stage2_1 = stage1_2 ^ stage1_3;

    // Final stage XOR
    assign parity = stage2_0 ^ stage2_1;
endmodule