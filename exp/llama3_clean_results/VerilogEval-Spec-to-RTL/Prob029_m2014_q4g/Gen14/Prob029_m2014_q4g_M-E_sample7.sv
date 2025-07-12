module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Internal wires for intermediate results
wire xnor_result;
wire and_in1_in2;
wire or_inv_in1_in2;

// Implement XNOR using AND and OR gates
assign and_in1_in2 = in1 & in2;
assign or_inv_in1_in2 = ~in1 | ~in2;
assign xnor_result = and_in1_in2 | or_inv_in1_in2;

// Implement XOR with in3 using the XNOR result
assign out = ~(xnor_result & in3) & (~xnor_result | in3) | (xnor_result & ~in3);

endmodule