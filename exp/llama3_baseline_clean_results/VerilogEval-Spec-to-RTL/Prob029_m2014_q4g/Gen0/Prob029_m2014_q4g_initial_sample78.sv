module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Internal signal to hold the output of the XNOR operation
wire xnor_out;

// Perform the XNOR operation between in1 and in2
assign xnor_out = in1 == in2;

// Perform the XOR operation between the XNOR output and in3
assign out = xnor_out ^ in3;

endmodule