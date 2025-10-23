module TopModule(
    input  [7:0] in,  // 8-bit input
    output parity     // 1-bit output
);

// Compute the parity bit by XORing all 8 input bits
assign parity = ^in;

endmodule