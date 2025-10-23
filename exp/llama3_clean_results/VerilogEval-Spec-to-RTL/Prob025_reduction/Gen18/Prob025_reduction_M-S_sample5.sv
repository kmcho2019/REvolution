// Simplified module with direct parity calculation
module TopModule(
    input  [7:0] in,  // 8-bit input byte
    output parity    // 1-bit output for even parity
);

// Directly calculate the final parity by XORing all input bits
assign parity = ^in;

endmodule