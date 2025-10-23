module TopModule (
    input  [7:0] in,
    output       parity
);
    // Level 1 XOR: XOR pairs of bits
    wire xor01 = in[0] ^ in[1];
    wire xor23 = in[2] ^ in[3];
    wire xor45 = in[4] ^ in[5];
    wire xor67 = in[6] ^ in[7];

    // Level 2 XOR: XOR results of level 1
    wire xor0123 = xor01 ^ xor23;
    wire xor4567 = xor45 ^ xor67;

    // Level 3 XOR: Final XOR to get parity
    assign parity = xor0123 ^ xor4567;
endmodule