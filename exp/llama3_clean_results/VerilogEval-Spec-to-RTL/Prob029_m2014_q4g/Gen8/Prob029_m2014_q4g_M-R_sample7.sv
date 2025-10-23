module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Intermediate signal to hold the result of XNOR operation between in1 and in2
wire xnor_result;

// Implement XNOR operation between in1 and in2
assign xnor_result = ~(in1 ^ in2);

// Use the XNOR result and in3 to compute the final output
assign out = xnor_result ^ in3;

endmodule