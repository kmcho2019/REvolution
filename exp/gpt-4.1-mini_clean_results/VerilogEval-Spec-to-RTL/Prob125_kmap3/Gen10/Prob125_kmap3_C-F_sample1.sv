module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // don't-care input, ignored
    output out
);

// Inverted inputs for reuse
wire not_b = ~b;
wire not_c = ~c;

// Common sub-expression: (a | ~b)
wire a_or_not_b = a | not_b;

// term1: ~c & a
wire term1 = not_c & a;

// term2: c & (a | ~b)
wire term2 = c & a_or_not_b;

assign out = term1 | term2;

endmodule