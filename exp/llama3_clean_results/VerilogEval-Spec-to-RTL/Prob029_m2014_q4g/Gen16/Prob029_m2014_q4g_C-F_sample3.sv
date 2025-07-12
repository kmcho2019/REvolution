module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Intermediate signal for the XNOR operation
wire xnor_result;

// Compute XNOR of in1 and in2
assign xnor_result = ~(in1 ^ in2);

// Compute XOR of xnor_result and in3, and assign it to out
assign out = xnor_result ^ in3;

endmodule