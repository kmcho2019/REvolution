module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output out
);

wire xnor_out;

// Instantiate a two-input XNOR gate
xnor u_xnor (
    .a(in1),
    .b(in2),
    .y(xnor_out)
);

// Instantiate a two-input XOR gate
xor u_xor (
    .a(xnor_out),
    .b(in3),
    .y(out)
);

endmodule