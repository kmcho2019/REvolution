module TopModule(
    input  [7:0] in,    // 8-bit input
    output       parity // parity bit
);

assign parity = ^in;  // compute XOR of all bits in in

endmodule