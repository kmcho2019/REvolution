module XnorGate (
    input a,
    input b,
    output y
);
    assign y = ~(a ^ b);
endmodule

module XorGate (
    input a,
    input b,
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

    XnorGate u1 (
        .a(in1),
        .b(in2),
        .y(xnor_out)
    );

    XorGate u2 (
        .a(xnor_out),
        .b(in3),
        .y(out)
    );
endmodule