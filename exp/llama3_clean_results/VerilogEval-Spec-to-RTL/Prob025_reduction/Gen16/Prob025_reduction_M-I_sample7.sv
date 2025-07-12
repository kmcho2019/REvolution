module TopModule(
    input [7:0] in,  // 8-bit input
    output parity  // 1-bit parity output
);

assign parity = ^in; // Using reduction XOR operator on the entire vector

endmodule