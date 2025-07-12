module TopModule (
    input [7:0] in,  // 8-bit input
    output parity  // parity bit
);

assign parity = ^in;  // calculate the XOR of all bits in the input byte

endmodule