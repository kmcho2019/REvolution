module OR_Gate(
    input  a,
    input  b,
    output q
);

assign q = a | b;

endmodule

module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Modular approach using OR_Gate module
OR_Gate or_gate(
   .a(b),
   .b(c),
   .q(q)
);

endmodule