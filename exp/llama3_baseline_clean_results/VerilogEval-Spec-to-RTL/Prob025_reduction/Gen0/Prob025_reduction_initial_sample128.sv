module TopModule(
    input  [7:0] in,  // 8-bit input
    output parity      // parity bit
);

assign parity = ^in;  // XOR all bits of the input vector to get the parity bit

endmodule