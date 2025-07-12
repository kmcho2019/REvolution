module TopModule(
    input  [7:0] in,    // 8-bit input
    output parity     // 1-bit output parity
);

assign parity = ^in;  // Compute parity bit as XOR of all input bits

endmodule