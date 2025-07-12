module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

wire xnor_result; // Intermediate wire to hold the XNOR result
assign xnor_result = ~(in1 ^ in2); // Compute XNOR of in1 and in2
assign out = xnor_result ^ in3; // XOR the XNOR result with in3 to get the final output

endmodule