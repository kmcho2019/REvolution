module OR_Gate(
    input  a,
    input  b,
    output q
);

assign q = a || b;

endmodule

module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

wire or_result;
OR_Gate or_gate1(
  .a(b),
  .b(c),
  .q(or_result)
);

OR_Gate or_gate2(
  .a(a),
  .b(or_result),
  .q(q)
);

endmodule