module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

// Intermediate signal for XNOR operation
wire xnor_out;

// Compute XNOR of in1 and in2
assign xnor_out = !(in1 ^ in2);

// Compute XOR of xnor_out and in3 to get the final output
assign out = xnor_out ^ in3;

endmodule