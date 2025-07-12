module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // don't-care input, ignored
    output out
);

// Inverted inputs reused to save gates
wire not_b = ~b;
wire not_c = ~c;

// Common sub-expression for reuse and clarity
wire a_or_not_b = a | not_b;

// Two main terms from the minimal sum-of-products form
wire term1 = not_c & a;
wire term2 = c & a_or_not_b;

assign out = term1 | term2;

endmodule