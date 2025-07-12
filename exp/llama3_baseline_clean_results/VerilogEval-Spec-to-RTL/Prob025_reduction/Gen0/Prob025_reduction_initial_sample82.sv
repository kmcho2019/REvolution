module TopModule(
    input  [7:0] in,     // 8-bit input
    output parity      // even parity bit
);

assign parity = ^in;   // calculate even parity bit using XOR reduction

endmodule