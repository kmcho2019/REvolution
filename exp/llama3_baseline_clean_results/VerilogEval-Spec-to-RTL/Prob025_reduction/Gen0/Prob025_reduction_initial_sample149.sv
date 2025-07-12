module TopModule(
    input [7:0] in,  // 8-bit input
    output parity   // 1-bit output for parity
);

// Assign the parity output to the XOR of all input bits
assign parity = ^in;

endmodule