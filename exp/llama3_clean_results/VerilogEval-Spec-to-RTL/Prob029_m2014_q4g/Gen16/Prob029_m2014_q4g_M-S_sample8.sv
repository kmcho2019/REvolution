module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Implement the XNOR operation directly
wire xnor_result = ~(in1 ^ in2);

// Implement the XOR operation with in3
assign out = xnor_result ^ in3;

endmodule