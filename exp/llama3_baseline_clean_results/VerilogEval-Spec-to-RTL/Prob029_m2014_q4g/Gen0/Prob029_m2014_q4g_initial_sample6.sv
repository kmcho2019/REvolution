module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

// Implementing the two-input XNOR gate
wire xnor_out;
assign xnor_out = ~(in1 ^ in2); // Using XOR and then inverting

// Implementing the two-input XOR gate with xnor_out and in3
assign out = xnor_out ^ in3;

endmodule