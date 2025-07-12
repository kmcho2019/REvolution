module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Intermediate signal for the XNOR operation between in1 and in2
wire xnor_out;

// Assign the XNOR operation result to xnor_out
assign xnor_out = ~(in1 ^ in2);

// Final output out is the result of XOR operation between xnor_out and in3
assign out = xnor_out ^ in3;

endmodule