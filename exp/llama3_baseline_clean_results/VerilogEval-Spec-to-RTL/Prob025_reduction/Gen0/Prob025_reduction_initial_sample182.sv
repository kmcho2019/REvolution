module TopModule(
    input  [7:0] in,  // 8-bit input
    output parity     // 1-bit output
);

assign parity = ^in;  // compute the parity bit by XORing all bits of the input

endmodule