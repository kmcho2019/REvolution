module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output out
);

    // Two-input XNOR gate module
    module XNOR2 (
        input a,
        input b,
        output y
    );
        assign y = ~(a ^ b);
    endmodule

    // Two-input XOR gate module
    module XOR2 (
        input a,
        input b,
        output y
    );
        assign y = a ^ b;
    endmodule

    wire xnor_out;

    // Instantiate XNOR2 and XOR2 inside TopModule
    XNOR2 u_xnor (
        .a(in1),
        .b(in2),
        .y(xnor_out)
    );

    XOR2 u_xor (
        .a(xnor_out),
        .b(in3),
        .y(out)
    );

endmodule