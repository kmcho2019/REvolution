module OR_Gate_3Input(
    input  a,
    input  b,
    input  c,
    output q
);

assign q = a || b || c;

endmodule

module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

OR_Gate_3Input or_gate(
   .a(a),
   .b(b),
   .c(c),
   .q(q)
);

endmodule