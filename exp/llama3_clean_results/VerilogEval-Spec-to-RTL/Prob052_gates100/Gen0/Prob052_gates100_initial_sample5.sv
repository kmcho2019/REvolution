module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

// Initialize variables to store results of AND, OR, and XOR operations
reg and_result;
reg or_result;
reg xor_result;

// Calculate the AND of all bits in the input
assign and_result = &in;

// Calculate the OR of all bits in the input
assign or_result = |in;

// Calculate the XOR of all bits in the input
assign xor_result = ^in;

// Assign results to output ports
assign out_and = and_result;
assign out_or = or_result;
assign out_xor = xor_result;

endmodule