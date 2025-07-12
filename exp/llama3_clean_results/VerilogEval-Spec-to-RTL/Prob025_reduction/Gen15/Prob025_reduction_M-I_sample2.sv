module TopModule(
    input [7:0] in,  // 8-bit input
    output parity  // 1-bit parity output
);

// Maintain the existing efficient design
assign parity = ^in; // Using reduction XOR operator on the entire vector

// Consider adding synthesis directives or attributes for power optimization
// if supported by the technology or synthesis tool being used.

endmodule