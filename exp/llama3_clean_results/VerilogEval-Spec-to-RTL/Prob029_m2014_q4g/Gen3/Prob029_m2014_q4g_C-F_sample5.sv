module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Combine XNOR and XOR operations using equality operator and XOR
assign out = (in1 == in2) ^ in3;

// Alternatively, we can also use the Boolean algebra simplification
// assign out = ~(in1 ^ in2) ^ in3;

endmodule