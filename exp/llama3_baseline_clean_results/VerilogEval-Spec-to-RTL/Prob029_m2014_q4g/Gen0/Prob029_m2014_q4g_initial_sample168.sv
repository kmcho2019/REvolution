module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Internal signal to hold the output of the XNOR gate
wire xnor_out;

// XNOR operation
assign xnor_out = ~(in1 ^ in2);

// XOR operation using the output of XNOR and in3
assign out = xnor_out ^ in3;

endmodule