module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

// Create a two-input XNOR gate
wire xnor_out;
assign xnor_out = ~(in1 ^ in2);

// Create a two-input XOR gate with xnor_out and in3 as inputs
assign out = xnor_out ^ in3;

endmodule