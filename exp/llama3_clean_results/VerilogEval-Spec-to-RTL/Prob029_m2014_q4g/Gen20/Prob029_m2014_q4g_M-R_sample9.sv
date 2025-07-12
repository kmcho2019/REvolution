// TopModule
module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Directly use the XOR operation and apply negation for XNOR
assign out = ~(in1 ^ in2) ^ in3;

endmodule