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

    // Instantiate XNOR gate for in1 and in2
    XNOR2 u_xnor2 (
        .a(in1),
        .b(in2),
        .y(xnor_out)
    );

    // Instantiate XOR gate for xnor_out and in3
    XOR2 u_xor2 (
        .a(xnor_out),
        .b(in3),
        .y(out)
    );
endmodule