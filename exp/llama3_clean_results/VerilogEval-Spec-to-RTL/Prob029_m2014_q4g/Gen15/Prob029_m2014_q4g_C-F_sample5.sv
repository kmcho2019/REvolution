module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Direct computation using equality operator for XNOR and XOR operator
assign out = (in1 == in2) ^ in3;

endmodule