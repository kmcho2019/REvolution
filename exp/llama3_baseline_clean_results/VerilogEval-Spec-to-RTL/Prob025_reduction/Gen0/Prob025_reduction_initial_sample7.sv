module TopModule(
    input [7:0] in,  // 8-bit input
    output parity   // parity bit output
);

// Compute the parity bit by XORing all 8 data bits together
assign parity = ^in;

endmodule