module TopModule(
    input  [7:0] in,  // 8-bit input
    output parity    // 1-bit output for parity
);

// Calculate the parity bit by XORing all 8 bits of the input
assign parity = ^in;

endmodule