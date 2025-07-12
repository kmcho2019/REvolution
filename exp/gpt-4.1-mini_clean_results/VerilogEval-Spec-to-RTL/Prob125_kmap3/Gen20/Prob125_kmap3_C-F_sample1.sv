module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // don't care, unused
    output out
);

// Intermediate signals for inverted inputs and partial expressions
wire not_b = ~b;
wire not_c = ~c;

wire a_or_not_b = a | not_b;

wire term1 = a & not_c;       // a & ~c
wire term2 = c & a_or_not_b;  // c & (a | ~b)

assign out = term1 | term2;

endmodule