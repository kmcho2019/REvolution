module TopModule(
    input  [7:0] in,  // 8-bit input
    output parity    // 1-bit output for parity
);

assign parity = ^in;  // Compute even parity by XORing all bits

endmodule