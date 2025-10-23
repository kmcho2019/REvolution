module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

// Implementing two-input XNOR gate
wire xnor_out;
assign xnor_out = ~(in1 ^ in2); // XNOR is equivalent to ~(a ^ b)

// Implementing two-input XOR gate
assign out = xnor_out ^ in3;

endmodule