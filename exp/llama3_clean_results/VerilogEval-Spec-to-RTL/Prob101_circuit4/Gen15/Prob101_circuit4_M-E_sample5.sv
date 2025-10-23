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

wire or_out;
OR_Gate or_gate(
  .a(b),
  .b(c),
  .q(or_out)
);

assign q = a? (b || c || d) : or_out;

endmodule