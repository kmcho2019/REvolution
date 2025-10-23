module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // don't care input, ignored in logic
    output out
);

wire term_a = a;
wire term_cnb = c & ~b;

assign out = term_a | term_cnb;

endmodule