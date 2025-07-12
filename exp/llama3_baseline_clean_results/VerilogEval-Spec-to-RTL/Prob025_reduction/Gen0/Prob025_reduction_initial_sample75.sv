module TopModule(
    input  [7:0] in,  // 8-bit input
    output parity    // 1-bit output
);

assign parity = ^in;  // Compute the XOR of all bits in the input

endmodule