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

    assign and_out1 = a & b;
    assign and_out2 = c & d;

    OR_Gate or_gate(
      .a(and_out1),
      .b(and_out2),
      .out(out)
    );

    assign out_n = ~out;
endmodule