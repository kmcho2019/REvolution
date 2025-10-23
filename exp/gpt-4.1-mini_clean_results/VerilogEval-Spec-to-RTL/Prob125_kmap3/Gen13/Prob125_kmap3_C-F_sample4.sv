module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // don't care, unused
    output out
);

// Intermediate signals for product terms
wire not_b = ~b;
wire not_c = ~c;

wire term1 = c & a;     // c & a
wire term2 = c & not_b; // c & ~b
wire term3 = a & not_c; // a & ~c

assign out = term1 | term2 | term3;

endmodule