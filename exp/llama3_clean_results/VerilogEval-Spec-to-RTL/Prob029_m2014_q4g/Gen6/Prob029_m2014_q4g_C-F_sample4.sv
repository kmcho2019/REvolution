module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Directly combine XNOR and XOR operations using XOR and negation properties
assign out = ~(in1 ^ in2) ^ in3;

endmodule