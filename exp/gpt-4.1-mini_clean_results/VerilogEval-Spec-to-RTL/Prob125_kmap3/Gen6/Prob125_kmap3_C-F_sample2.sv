module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // don't care, ignored
    output out
);

// Intermediate inverted signals for clarity
wire not_c = ~c;
wire not_b = ~b;

// term1: ~c & a
wire term1 = not_c & a;

// term2: c & (~b | a)
wire term2 = c & (not_b | a);

assign out = term1 | term2;

endmodule