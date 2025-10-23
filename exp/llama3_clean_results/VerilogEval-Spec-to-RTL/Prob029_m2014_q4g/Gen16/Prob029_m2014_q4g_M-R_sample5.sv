module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Temporary variable to hold the result of the XNOR operation
wire xnor_result;

// XNOR operation between in1 and in2 using equality comparison
assign xnor_result = ~(in1 ^ in2);

// Final output: XOR operation between xnor_result and in3
assign out = xnor_result ^ in3;

endmodule