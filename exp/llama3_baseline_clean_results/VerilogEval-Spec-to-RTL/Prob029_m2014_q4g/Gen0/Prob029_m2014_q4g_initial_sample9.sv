module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

wire xnor_out;

// Implementing XNOR using XOR and negation
assign xnor_out = ~(in1 ^ in2);

// Implementing XOR with xnor_out and in3
assign out = xnor_out ^ in3;

endmodule