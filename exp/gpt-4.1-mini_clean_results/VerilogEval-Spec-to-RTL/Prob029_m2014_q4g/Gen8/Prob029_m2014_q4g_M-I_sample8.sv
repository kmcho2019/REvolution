module TopModule (
    input in1,
    input in2,
    input in3,
    output out
);

// Intermediate wire for XNOR output
wire xnor_out;

// Explicit gate-level instantiation for XNOR and XOR
xnor u_xnor (
    .a(in1),
    .b(in2),
    .y(xnor_out)
);

xor u_xor (
    .a(xnor_out),
    .b(in3),
    .y(out)
);

endmodule