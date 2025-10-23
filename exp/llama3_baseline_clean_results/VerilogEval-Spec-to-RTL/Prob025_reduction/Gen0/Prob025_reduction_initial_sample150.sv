module TopModule(
    input [7:0] in,  // 8-bit input
    output parity   // parity bit output
);

// Compute the parity bit as the XOR of all 8 data bits
assign parity = ^in;

endmodule