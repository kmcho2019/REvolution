module TopModule (
    input  [7:0] in,
    output       parity
);
    wire xor0, xor1, xor2, xor3;
    wire xor01, xor23;

    // Stage 1: XOR pairs of bits
    assign xor0 = in[0] ^ in[1];
    assign xor1 = in[2] ^ in[3];
    assign xor2 = in[4] ^ in[5];
    assign xor3 = in[6] ^ in[7];

    // Stage 2: XOR results of stage 1
    assign xor01 = xor0 ^ xor1;
    assign xor23 = xor2 ^ xor3;

    // Stage 3: Final XOR to compute even parity
    assign parity = xor01 ^ xor23;

endmodule