module A_Condition(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

assign q = (a && !(b || c)) ? 0 : (a ? 1 : 0);

endmodule

module BC_Condition(
    input  a,
    input  b,
    input  c,
    input  d,
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

wire a_cond;
wire bc_cond;

A_Condition a_condition(
    .a(a),
    .b(b),
    .c(c),
    .d(d),
    .q(a_cond)
);

BC_Condition bc_condition(
    .a(a),
    .b(b),
    .c(c),
    .d(d),
    .q(bc_cond)
);

assign q = a_cond || bc_cond;

endmodule