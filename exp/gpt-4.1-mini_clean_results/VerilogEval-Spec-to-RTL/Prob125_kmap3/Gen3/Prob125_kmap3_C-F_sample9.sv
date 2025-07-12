module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // don't-care input, ignored
    output out
);

wire not_c = ~c;
wire not_b = ~b;

wire or_term = not_b | a;

wire and_c_or = c & or_term;
wire and_notc_a = not_c & a;

assign out = and_notc_a | and_c_or;

endmodule