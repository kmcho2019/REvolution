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

// Intermediate OR gate for b and c
wire bc_or;
OR_Gate bc_or_gate(
   .a(b),
   .b(c),
   .q(bc_or)
);

// Final OR gate for a and the result of bc_or
OR_Gate abc_or_gate(
   .a(a),
   .b(bc_or),
   .q(q)
);

endmodule