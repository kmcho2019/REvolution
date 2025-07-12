module TopModule(
    input  [7:0] in,  // 8-bit input
    output parity      // parity bit
);

assign parity = ^in;  // Calculate parity bit using XOR operation

endmodule