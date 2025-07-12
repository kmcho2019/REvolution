module TopModule(
    input  [7:0] in,  // Input 8-bit byte
    output parity    // Output parity bit
);

// Compute the parity bit by XORing all the bits of the input byte
assign parity = ^in;  // The ^ operator computes the XOR of all bits in the vector in

endmodule