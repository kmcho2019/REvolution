module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Intermediate signals for the XNOR operation
wire xnor_and_result;
wire xnor_or_result;
wire not_in1;
wire not_in2;

// Intermediate signals for the XOR operation
wire xor_and_result1;
wire xor_and_result2;
wire not_xnor_result;

// Implement the XNOR operation
assign not_in1 = ~in1;
assign not_in2 = ~in2;
assign xnor_and_result = in1 & in2;
assign xnor_or_result = not_in1 & not_in2;

// Combine the results of the AND and OR operations for XNOR
assign out_xnor = xnor_and_result | xnor_or_result;

// Implement the XOR operation with in3
assign not_xnor_result = ~out_xnor;
assign xor_and_result1 = out_xnor & ~in3;
assign xor_and_result2 = not_xnor_result & in3;

// Combine the results of the AND operations for XOR
assign out = xor_and_result1 | xor_and_result2;

endmodule