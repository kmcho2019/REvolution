module TopModule (
    input [7:0] in,
    output parity
);
    // First level XORs (4 operations)
    wire level1_0 = in[0] ^ in[1];
    wire level1_1 = in[2] ^ in[3];
    wire level1_2 = in[4] ^ in[5];
    wire level1_3 = in[6] ^ in[7];

    // Second level XORs (2 operations)
    wire level2_0 = level1_0 ^ level1_1;
    wire level2_1 = level1_2 ^ level1_3;

    // Final XOR
    assign parity = level2_0 ^ level2_1;
endmodule