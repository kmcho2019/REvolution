// Novel module to calculate the even parity bit for an 8-bit input byte using a tree-like structure of XOR gates
module TopModule(
    input  [7:0] in,  // 8-bit input byte
    output parity    // 1-bit output for even parity
);

// Group the input bits into pairs and compute their XORs
wire xor_0_1 = in[0] ^ in[1];
wire xor_2_3 = in[2] ^ in[3];
wire xor_4_5 = in[4] ^ in[5];
wire xor_6_7 = in[6] ^ in[7];

// Compute the XOR of the pairs
wire xor_0_3 = xor_0_1 ^ xor_2_3;
wire xor_4_7 = xor_4_5 ^ xor_6_7;

// Compute the final parity bit
assign parity = xor_0_3 ^ xor_4_7;

endmodule