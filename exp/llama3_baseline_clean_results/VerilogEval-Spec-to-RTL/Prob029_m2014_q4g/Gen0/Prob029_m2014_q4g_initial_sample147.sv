module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Implementing the XNOR gate using XOR and inverting its output
wire xnor_out;
assign xnor_out = ~(in1 ^ in2);

// Implementing the XOR gate using the output of the XNOR gate and in3 as inputs
assign out = xnor_out ^ in3;

endmodule