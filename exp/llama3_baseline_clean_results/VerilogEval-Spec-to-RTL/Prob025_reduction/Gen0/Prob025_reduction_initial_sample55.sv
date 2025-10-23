module TopModule(
    input  [7:0] in,    // 8-bit input
    output       parity // 1-bit output
);

// Calculate parity using XOR of all bits
assign parity = in[0] ^ in[1] ^ in[2] ^ in[3] ^ in[4] ^ in[5] ^ in[6] ^ in[7];

endmodule