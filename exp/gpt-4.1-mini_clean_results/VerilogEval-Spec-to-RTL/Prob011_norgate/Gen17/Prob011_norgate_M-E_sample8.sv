module ORGate(
    input in1,
    input in2,
    output out
);
    assign out = in1 | in2;
endmodule

module NOTGate(
    input in,
    output out
);
    assign out = ~in;
endmodule

module TopModule (
    input  a,
    input  b,
    output out
);
    wire or_out;

    ORGate or_inst(
        .in1(a),
        .in2(b),
        .out(or_out)
    );

    NOTGate not_inst(
        .in(or_out),
        .out(out)
    );
endmodule