module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Implement the XNOR operation using boolean properties
wire xnor_result = ~(in1 ^ in2);

// Apply the XOR operation with 'in3'
assign out = xnor_result ^ in3;

endmodule