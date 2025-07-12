module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Implementing the XNOR of in1 and in2, followed by an XOR with in3, in a manner that emphasizes direct computation for synthesis optimization
assign out = ~(in1 ^ in2) ^ in3;

endmodule