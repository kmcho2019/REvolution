module BC_Logic(
    input  b,
    input  c,
    output q
);

assign q = b || c;

endmodule

module A_Logic(
    input  a,
    output q
);

assign q = a;

endmodule

module Final_Logic(
    input  a,
    input  b,
    input  c,
    output q
);

wire bc_q;
BC_Logic bc_logic(
    .b(b),
    .c(c),
    .q(bc_q)
);

wire a_q;
A_Logic a_logic(
    .a(a),
    .q(a_q)
);

assign q = bc_q || a_q;

endmodule

module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

Final_Logic final_logic(
    .a(a),
    .b(b),
    .c(c),
    .q(q)
);

endmodule