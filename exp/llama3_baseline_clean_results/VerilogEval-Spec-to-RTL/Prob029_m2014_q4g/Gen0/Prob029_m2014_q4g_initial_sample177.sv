module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

assign out = (in1 === in2) ^ in3;

// Alternatively, you could use the following for explicit XNOR and XOR operations
// assign out = ~(in1 ^ in2) ^ in3;

endmodule