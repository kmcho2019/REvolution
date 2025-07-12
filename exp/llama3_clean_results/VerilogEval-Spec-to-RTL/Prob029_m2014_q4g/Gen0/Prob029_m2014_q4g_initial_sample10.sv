module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Compute XNOR of in1 and in2
wire xnor_out;
assign xnor_out = ~(in1 ^ in2); // XNOR can be achieved by inverting the result of XOR

// Compute XOR of xnor_out and in3
assign out = xnor_out ^ in3;

endmodule