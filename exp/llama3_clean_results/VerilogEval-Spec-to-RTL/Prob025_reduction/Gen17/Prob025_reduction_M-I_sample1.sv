// Improved module for calculating the parity of an 8-bit byte
module TopModule(
    input  [7:0] in,  // 8-bit input byte
    output parity    // 1-bit output for even parity
);

// Calculate the parity directly by XORing all 8 bits
assign parity = in[0] ^ in[1] ^ in[2] ^ in[3] ^ in[4] ^ in[5] ^ in[6] ^ in[7];

endmodule