module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // d is don't-care, ignored
    output out
);

// Intermediate inverted signals for reuse
wire not_c = ~c;
wire not_b = ~b;

// Intermediate OR for ( ~b | a )
wire or_nb_a = not_b | a;

// Final output: (~c & a) | (c & ( ~b | a ))
assign out = (not_c & a) | (c & or_nb_a);

endmodule