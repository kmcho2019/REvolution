module TopModule(
    input [7:0] in,  // 8-bit input
    output parity  // 1-bit parity output
);

// The reduction operator (^) in Verilog can directly compute the XOR of all bits in a vector,
// making the manual XOR chain redundant and potentially less efficient.
assign parity = ^in;

endmodule