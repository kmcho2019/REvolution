module TopModule(
    input [7:0] in,  // 8-bit input
    output parity  // 1-bit parity output
);

// Using reduction XOR operator on the entire vector for simplicity and efficiency
assign parity = ^in;

endmodule