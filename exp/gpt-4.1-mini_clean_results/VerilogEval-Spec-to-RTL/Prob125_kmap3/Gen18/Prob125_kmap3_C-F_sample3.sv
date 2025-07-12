module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // don't-care, unused
    output out
);

// Inverted signals
wire not_b = ~b;
wire not_c = ~c;

// Intermediate OR term
wire a_or_not_b = a | not_b;

// Product terms
wire term1 = not_c & a;
wire term2 = c & a_or_not_b;

assign out = term1 | term2;

endmodule