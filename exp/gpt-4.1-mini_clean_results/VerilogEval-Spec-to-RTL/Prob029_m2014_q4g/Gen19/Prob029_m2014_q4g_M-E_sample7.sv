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
    wire xn_out;

    // Instantiate XNOR gate for (in1 XNOR in2)
    XNOR2 u_xnor (
        .a(in1),
        .b(in2),
        .y(xn_out)
    );

    // Instantiate XOR gate for (xn_out XOR in3)
    XOR2 u_xor (
        .a(xn_out),
        .b(in3),
        .y(out)
    );
endmodule