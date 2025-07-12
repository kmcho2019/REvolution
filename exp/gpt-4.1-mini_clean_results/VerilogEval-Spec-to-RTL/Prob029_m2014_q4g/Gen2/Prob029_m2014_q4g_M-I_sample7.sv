module TopModule (
    input in1,
    input in2,
    input in3,
    output out
);

wire xnor_out;

// Instantiate a two-input XNOR gate directly using the xnor primitive
xnor u_xnor (xnor_out, in1, in2);

// Instantiate a two-input XOR gate
xor u_xor (out, xnor_out, in3);

endmodule