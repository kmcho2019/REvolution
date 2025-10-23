module TopModule(
    input  [7:0] in,  // 8-bit input
    output parity     // 1-bit parity output
);

    assign parity = ^in;  // Compute parity bit as XOR of all 8 data bits

endmodule