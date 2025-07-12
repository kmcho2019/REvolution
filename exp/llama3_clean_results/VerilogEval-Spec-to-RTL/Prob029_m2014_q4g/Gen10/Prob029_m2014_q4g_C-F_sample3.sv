module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

// Directly compute the output by combining XNOR and XOR operations with focus on simplicity and readability
// Using an intermediate signal for XNOR to enhance readability
wire xnor_result = ~(in1 ^ in2);
assign out = xnor_result ^ in3;

endmodule