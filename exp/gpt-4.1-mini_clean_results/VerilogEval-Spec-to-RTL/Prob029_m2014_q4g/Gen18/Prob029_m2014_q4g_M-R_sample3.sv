module XNOR2 (
    input  a,
    input  b,
    output y
);
    assign y = ~(a ^ b);
endmodule

module XOR2 (
    input  a,
    input  b,
    output y
);
    assign y = a ^ b;
endmodule

module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output out
);
    wire xnor_out;

    // Instantiate XNOR gate
    XNOR2 u_xnor (
        .a(in1),
        .b(in2),
        .y(xnor_out)
    );

    // Instantiate XOR gate
    XOR2 u_xor (
        .a(xnor_out),
        .b(in3),
        .y(out)
    );
endmodule