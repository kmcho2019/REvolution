// Refactored module with direct parity calculation
module TopModule(
    input  [7:0] in,  // 8-bit input byte
    output parity    // 1-bit output for even parity
);

// Directly calculate the final parity by XORing the bits in two groups
assign parity = (in[3] ^ in[2] ^ in[1] ^ in[0]) ^ (in[7] ^ in[6] ^ in[5] ^ in[4]);

endmodule