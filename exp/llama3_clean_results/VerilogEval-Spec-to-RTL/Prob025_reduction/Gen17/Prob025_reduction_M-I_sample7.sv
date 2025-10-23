// Improved module combining efficiency and simplicity
module TopModule(
    input  [7:0] in,  // 8-bit input byte
    output parity    // 1-bit output for even parity
);

// Directly compute the parity by XORing all bits
assign parity = in[0] ^ in[1] ^ in[2] ^ in[3] ^ in[4] ^ in[5] ^ in[6] ^ in[7];

endmodule