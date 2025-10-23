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

    // Instantiate XNOR2 gate for (in1 XNOR in2)
    XNOR2 xnor_gate (
        .a(in1),
        .b(in2),
        .y(xnor_out)
    );

    // Instantiate XOR2 gate for (xnor_out XOR in3)
    XOR2 xor_gate (
        .a(xnor_out),
        .b(in3),
        .y(out)
    );
endmodule