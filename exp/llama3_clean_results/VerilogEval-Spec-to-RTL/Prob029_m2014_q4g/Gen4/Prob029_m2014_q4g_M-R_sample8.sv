module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

// Intermediate signal for XNOR operation
wire xnor_out;

// Perform XNOR operation between in1 and in2
assign xnor_out = ~(in1 ^ in2);

// Perform XOR operation between xnor_out and in3
assign out = xnor_out ^ in3;

endmodule