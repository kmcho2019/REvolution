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

wire temp;

OR_Gate or_gate1(
   .a(b),
   .b(c),
   .q(temp)
);

OR_Gate or_gate2(
   .a(a),
   .b(temp),
   .q(q)
);

endmodule