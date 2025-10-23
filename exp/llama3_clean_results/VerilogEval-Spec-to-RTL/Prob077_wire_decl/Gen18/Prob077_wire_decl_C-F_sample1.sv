module AND_Gate(
    input  a,
    input  b,
    output out
);
    assign out = a & b;
endmodule

module OR_Gate(
    input  a,
    input  b,
    output out
);
    assign out = a | b;
endmodule

module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    wire and_out1, and_out2;

    AND_Gate and_gate1(
       .a(a),
       .b(b),
       .out(and_out1)
    );

    AND_Gate and_gate2(
       .a(c),
       .b(d),
       .out(and_out2)
    );

    OR_Gate or_gate(
       .a(and_out1),
       .b(and_out2),
       .out(out)
    );

    assign out_n = ~out;
endmodule