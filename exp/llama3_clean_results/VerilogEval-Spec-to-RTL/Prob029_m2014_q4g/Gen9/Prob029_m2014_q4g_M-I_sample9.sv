module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

// Directly calculate the output by combining the XNOR and XOR operations
assign out = ~(in1 ^ in2) ^ in3;

endmodule