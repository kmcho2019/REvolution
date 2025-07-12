module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

// Basic logic gates for XNOR operation
wire not_in1, not_in2;
wire and_in1_in2, and_not_in1_not_in2;
wire or_and_in1_in2_and_not_in1_not_in2;
wire xnor_out;

// Basic logic gates for XOR operation
wire xor_in1_in3, xor_in1_not_in3, xor_not_in1_in3, xor_not_in1_not_in3;
wire and_xor_in1_in3_and_xor_not_in1_not_in3, and_xor_in1_not_in3_and_xor_not_in1_in3;
wire or_and_xor_in1_in3_and_xor_not_in1_not_in3_and_xor_in1_not_in3_and_xor_not_in1_in3;

// Assign the outputs of the basic logic gates
assign not_in1 = ~in1;
assign not_in2 = ~in2;
assign and_in1_in2 = in1 & in2;
assign and_not_in1_not_in2 = not_in1 & not_in2;
assign or_and_in1_in2_and_not_in1_not_in2 = and_in1_in2 | and_not_in1_not_in2;
assign xnor_out = or_and_in1_in2_and_not_in1_not_in2;

assign xor_in1_in3 = in1 & in3;
assign xor_in1_not_in3 = in1 & ~in3;
assign xor_not_in1_in3 = ~in1 & in3;
assign xor_not_in1_not_in3 = ~in1 & ~in3;
assign and_xor_in1_in3_and_xor_not_in1_not_in3 = xor_in1_in3 & xor_not_in1_not_in3;
assign and_xor_in1_not_in3_and_xor_not_in1_in3 = xor_in1_not_in3 & xor_not_in1_in3;
assign or_and_xor_in1_in3_and_xor_not_in1_not_in3_and_xor_in1_not_in3_and_xor_not_in1_in3 = and_xor_in1_in3_and_xor_not_in1_not_in3 | and_xor_in1_not_in3_and_xor_not_in1_in3;

// Assign the final output 'out'
assign out = or_and_xor_in1_in3_and_xor_not_in1_not_in3_and_xor_in1_not_in3_and_xor_not_in1_in3 ^ xnor_out;

endmodule