module TopModule(
    input [7:0] in,  // 8-bit input
    output wire parity  // 1-bit parity output
);

// Calculate the parity bit by XORing all input bits using vector XOR
assign parity = ^in;

endmodule