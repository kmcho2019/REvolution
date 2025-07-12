module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // don't care input, ignored
    output out
);

// Intermediate terms for clarity and synthesis optimization
wire term_a_nc  = a & ~c;
wire term_c_nb  = c & ~b;
wire term_c_a   = c & a;

// Final output is OR of the partial terms
assign out = term_a_nc | term_c_nb | term_c_a;

endmodule