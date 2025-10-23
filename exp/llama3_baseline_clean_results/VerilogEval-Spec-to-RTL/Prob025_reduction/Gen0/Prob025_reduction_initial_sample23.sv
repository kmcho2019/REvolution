module TopModule(
    input  [7:0] in,  // 8-bit input
    output parity    // 1-bit parity output
);

// Calculate the parity by XORing all input bits
assign parity = ^in;

endmodule