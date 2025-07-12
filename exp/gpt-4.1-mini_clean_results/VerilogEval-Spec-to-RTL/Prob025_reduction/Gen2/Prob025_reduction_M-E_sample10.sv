module TopModule (
    input  [7:0] in,
    output       parity
);
    wire xor_level1_0, xor_level1_1, xor_level1_2, xor_level1_3;
    wire xor_level2_0, xor_level2_1;

    // Level 1: XOR pairs of bits
    assign xor_level1_0 = in[0] ^ in[1];
    assign xor_level1_1 = in[2] ^ in[3];
    assign xor_level1_2 = in[4] ^ in[5];
    assign xor_level1_3 = in[6] ^ in[7];

    // Level 2: XOR results of level 1
    assign xor_level2_0 = xor_level1_0 ^ xor_level1_1;
    assign xor_level2_1 = xor_level1_2 ^ xor_level1_3;

    // Level 3: XOR results of level 2 -> final parity bit
    assign parity = xor_level2_0 ^ xor_level2_1;

endmodule