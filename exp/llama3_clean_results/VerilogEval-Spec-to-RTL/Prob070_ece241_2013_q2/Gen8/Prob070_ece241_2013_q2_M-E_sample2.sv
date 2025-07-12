module sum_of_products(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop
);

assign out_sop = (a && !b && c && !d) || (!a && b && c && d) || (a && b && c && d);

endmodule

module product_of_sums(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_pos
);

assign out_pos = !( (!a && !b && !c && !d) || (!a && !b && !c && d) || 
                   (!a && !b && c && !d) || (!a && !b && c && d) || 
                   (!a && b && !c && !d) || (!a && b && !c && d) || 
                   (!a && b && c && !d) || (a && !b && !c && !d) || 
                   (a && !b && !c && d) || (a && !b && c && !d) || 
                   (a && b && !c && !d) );

endmodule

module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

sum_of_products sop_module(
    .a(a),
    .b(b),
    .c(c),
    .d(d),
    .out_sop(out_sop)
);

product_of_sums pos_module(
    .a(a),
    .b(b),
    .c(c),
    .d(d),
    .out_pos(out_pos)
);

endmodule