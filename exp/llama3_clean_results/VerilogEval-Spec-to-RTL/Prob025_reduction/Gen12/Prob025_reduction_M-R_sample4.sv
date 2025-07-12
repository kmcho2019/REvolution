module TopModule(
    input [7:0] in,  // 8-bit input
    output parity  // 1-bit parity output
);

wire parity_calc = ^in;  // Calculate parity using a wire
assign parity = parity_calc;  // Assign calculated parity to output

endmodule