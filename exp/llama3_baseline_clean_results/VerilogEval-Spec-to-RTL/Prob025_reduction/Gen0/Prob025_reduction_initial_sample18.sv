module TopModule(
    input [7:0] in, // 8-bit input
    output parity   // parity bit
);

// Compute the parity bit by XORing all bits of the input byte
assign parity = ^in; // XOR operator (^) performs XOR on all bits of the input

endmodule