module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // don't-care input, ignored
    output out
);

wire not_c = ~c;
wire or_term = a | (~b);

assign out = (not_c & a) | (c & or_term);

endmodule