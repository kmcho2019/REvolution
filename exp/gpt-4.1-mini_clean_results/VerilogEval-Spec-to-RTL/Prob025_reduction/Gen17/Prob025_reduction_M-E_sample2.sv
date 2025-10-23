module TopModule (
    input  [7:0] in,
    output       parity
);
    wire xor0, xor1, xor2, xor3;
    wire xor4, xor5, xor6;

    // First layer: XOR pairs
    assign xor0 = in[0] ^ in[1];
    assign xor1 = in[2] ^ in[3];
    assign xor2 = in[4] ^ in[5];
    assign xor3 = in[6] ^ in[7];

    // Second layer: XOR results of first layer
    assign xor4 = xor0 ^ xor1;
    assign xor5 = xor2 ^ xor3;

    // Final layer: XOR the two results to get parity
    assign xor6 = xor4 ^ xor5;

    assign parity = xor6; // even parity bit
endmodule