module TopModule(
    input  [7:0] in,  // 8-bit input
    output parity  // 1-bit parity output
);

// Calculate the parity bit using a continuous assignment
assign parity = ^in;  // Using the vector XOR operator (^) for conciseness and efficiency

endmodule