module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

// Directly compute the output by combining XNOR and XOR operations with focus on simplicity and readability
assign out = ~(in1 ^ in2) ^ in3;

endmodule