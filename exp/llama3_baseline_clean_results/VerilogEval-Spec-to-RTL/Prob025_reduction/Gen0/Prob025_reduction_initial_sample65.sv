module TopModule(
    input  [7:0] in,  // 8-bit input
    output parity    // 1-bit output
);

assign parity = ^in;  // XOR all bits of in to get the parity bit

endmodule