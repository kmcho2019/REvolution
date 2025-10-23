module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Intermediate wire to hold the result of the XNOR operation
wire xnor_result;

// Compute the XNOR of in1 and in2
assign xnor_result = ~(in1 ^ in2);

// Compute the final output by XORing the XNOR result with in3
assign out = xnor_result ^ in3;

endmodule