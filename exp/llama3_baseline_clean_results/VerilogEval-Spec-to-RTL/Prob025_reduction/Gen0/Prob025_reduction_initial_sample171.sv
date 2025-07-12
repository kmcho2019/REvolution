module TopModule(
    input  [7:0] in,  // 8-bit input
    output parity      // parity bit output
);

assign parity = ^in;  // compute parity using XOR reduction operator

endmodule