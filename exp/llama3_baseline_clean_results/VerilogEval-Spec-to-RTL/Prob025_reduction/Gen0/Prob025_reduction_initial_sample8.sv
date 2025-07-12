module TopModule (
    input  [7:0] in,  // 8-bit input
    output parity    // 1-bit parity output
);

assign parity = ^in;  // XOR all bits in the input vector

endmodule