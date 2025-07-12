module Module_A(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

assign q = a;

endmodule

module Module_B(
    input  b,
    input  c,
    output q
);

assign q = b || c;

endmodule

module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

wire q_a, q_b;

Module_A module_a(
    .a(a),
    .b(b),
    .c(c),
    .d(d),
    .q(q_a)
);

Module_B module_b(
    .b(b),
    .c(c),
    .q(q_b)
);

assign q = a ? q_a : q_b;

endmodule