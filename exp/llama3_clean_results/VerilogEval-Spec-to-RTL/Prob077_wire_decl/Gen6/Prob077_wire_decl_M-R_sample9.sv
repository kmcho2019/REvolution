module AND_gate(
    input  a,
    input  b,
    output out
);
    assign out = (a && b)? 1'b1 : 1'b0;
endmodule

module OR_gate(
    input  a,
    input  b,
    output out
);
    assign out = (a || b)? 1'b1 : 1'b0;
endmodule

module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    wire and_out1, and_out2;

    AND_gate and1(
        .a(a),
        .b(b),
        .out(and_out1)
    );

    AND_gate and2(
        .a(c),
        .b(d),
        .out(and_out2)
    );

    OR_gate or1(
        .a(and_out1),
        .b(and_out2),
        .out(out)
    );

    assign out_n = ~out;
endmodule