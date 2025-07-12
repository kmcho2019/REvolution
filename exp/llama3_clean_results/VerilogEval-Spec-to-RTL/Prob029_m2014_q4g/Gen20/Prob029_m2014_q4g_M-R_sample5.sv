module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Directly implement the XNOR operation
wire xnor_out;
assign xnor_out = ~(in1 ^ in2);

// Then, directly implement the XOR operation with the XNOR output and in3
assign out = xnor_out ^ in3;

endmodule