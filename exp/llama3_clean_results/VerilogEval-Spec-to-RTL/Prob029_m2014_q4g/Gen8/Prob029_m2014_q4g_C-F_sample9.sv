module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

// Intermediate signal for the simplified expression of XNOR(in1, in2)
wire xnor_out;

// Compute the XNOR of in1 and in2 using the simplified expression
assign xnor_out = ~(in1 ^ in2);

// Compute the final output by XORing xnor_out with in3
assign out = xnor_out ^ in3;

endmodule