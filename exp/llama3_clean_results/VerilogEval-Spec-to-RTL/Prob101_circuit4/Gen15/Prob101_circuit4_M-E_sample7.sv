module A_Check(
    input  a,
    output q
);

assign q = a;

endmodule

module BC_OR(
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

wire a_high;
wire bc_or;

A_Check a_check(
    .a(a),
    .q(a_high)
);

BC_OR bc_or_gate(
    .b(b),
    .c(c),
    .q(bc_or)
);

assign q = a_high || bc_or;

endmodule