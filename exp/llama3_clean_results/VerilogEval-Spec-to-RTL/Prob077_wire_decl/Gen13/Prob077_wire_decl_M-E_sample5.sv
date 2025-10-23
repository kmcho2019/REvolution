module AND2(
    input  a,
    input  b,
    output out
);
    assign out = a & b;
endmodule

module OR2(
    input  a,
    input  b,
    output out
);
    assign out = a | b;
endmodule

module NOT(
    input  a,
    output out
);
    assign out = ~a;
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

    AND2 and_gate1(
       .a(a),
       .b(b),
       .out(and_out1)
    );

    AND2 and_gate2(
       .a(c),
       .b(d),
       .out(and_out2)
    );

    OR2 or_gate(
       .a(and_out1),
       .b(and_out2),
       .out(out)
    );

    NOT not_gate(
       .a(out),
       .out(out_n)
    );
endmodule