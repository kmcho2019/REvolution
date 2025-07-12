module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // d is don't-care, ignored in logic
    output out
);

// Intermediate signals for product terms:
// term1 = a & ~c  corresponds to (a & ~c)
// term2 = c & a   corresponds to (c & a)
// term3 = c & ~b  corresponds to (c & ~b)

wire not_c = ~c;
wire not_b = ~b;

wire term1 = a & not_c;
wire term2 = c & a;
wire term3 = c & not_b;

assign out = term1 | (term2 | term3);

endmodule