module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Directly compute the XNOR of in1 and in2, and then XOR this result with in3
assign out = ~(in1 ^ in2) ^ in3;

endmodule