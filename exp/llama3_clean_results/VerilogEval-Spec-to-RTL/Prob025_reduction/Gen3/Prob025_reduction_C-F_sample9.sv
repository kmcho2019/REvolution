module TopModule(
    input  [7:0] in,  // 8-bit input
    output parity    // 1-bit output for parity
);

// Compute even parity by XORing all bits of the input vector
assign parity = ^in;

endmodule