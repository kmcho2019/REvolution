module TopModule (
    input in1,
    input in2,
    input in3,
    output out
);

    wire xnor_out;

    // Instantiate an XNOR gate for in1 and in2
    xnor u_xnor (
        .a(in1),
        .b(in2),
        .y(xnor_out)
    );

    // Instantiate an XOR gate with xnor_out and in3
    xor u_xor (
        .a(xnor_out),
        .b(in3),
        .y(out)
    );

endmodule