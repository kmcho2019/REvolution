module TopModule (
    input  [7:0] in,
    output      parity
);
    wire xor_level1_0 = in[0] ^ in[1];
    wire xor_level1_1 = in[2] ^ in[3];
    wire xor_level1_2 = in[4] ^ in[5];
    wire xor_level1_3 = in[6] ^ in[7];

    wire xor_level2_0 = xor_level1_0 ^ xor_level1_1;
    wire xor_level2_1 = xor_level1_2 ^ xor_level1_3;

    assign parity = xor_level2_0 ^ xor_level2_1;
endmodule