module TopModule(
    input  [7:0] in,    // 8-bit input
    output parity      // even parity output
);

// Calculate the even parity bit by XORing all 8 input bits
assign parity = ^in;  // ^ operator performs XOR of all bits in the vector

endmodule