module OrGate (
    input  a,
    input  b,
    output y
);
    assign y = a | b;
endmodule

module NotGate (
    input  a,
    output y
);
    assign y = ~a;
endmodule

module TopModule (
    input  in1,
    input  in2,
    output out
);
    wire or_out;

    OrGate u_or (
        .a(in1),
        .b(in2),
        .y(or_out)
    );

    NotGate u_not (
        .a(or_out),
        .y(out)
    );
endmodule