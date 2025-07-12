module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Implement XNOR gate
wire xnor_out;
assign xnor_out = ~(in1 ^ in2); // in1 XNOR in2 is equivalent to !(in1 XOR in2)

// Implement XOR gate with xnor_out and in3 as inputs
assign out = xnor_out ^ in3;

endmodule