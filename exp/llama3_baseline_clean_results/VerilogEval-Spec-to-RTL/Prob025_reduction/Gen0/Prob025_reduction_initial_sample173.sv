module TopModule(
    input [7:0] in,  // 8-bit input
    output parity   // 1-bit output for parity
);

// Calculate parity by XORing all bits of the input
assign parity = ^in;

endmodule