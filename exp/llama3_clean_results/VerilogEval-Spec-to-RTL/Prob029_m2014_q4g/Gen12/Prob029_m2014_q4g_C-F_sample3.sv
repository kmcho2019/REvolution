module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Directly compute the output using a simplified expression
// This expression is efficient and directly implements the XNOR and XOR operations
assign out = ~(in1 ^ in2) ^ in3;

endmodule