module ConditionalAssignment(
    input  b,
    input  c,
    output q
);

assign q = b? 1'b1 : c;

endmodule

module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Modular approach using ConditionalAssignment module
ConditionalAssignment cond_assign(
   .b(b),
   .c(c),
   .q(q)
);

endmodule