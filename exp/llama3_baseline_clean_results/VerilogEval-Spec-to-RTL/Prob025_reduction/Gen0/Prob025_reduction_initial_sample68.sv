module TopModule(
    input  [7:0] in,  // 8-bit input
    output parity     // output parity bit
);

// Compute the parity bit by XORing all input bits
assign parity = ^in;

endmodule