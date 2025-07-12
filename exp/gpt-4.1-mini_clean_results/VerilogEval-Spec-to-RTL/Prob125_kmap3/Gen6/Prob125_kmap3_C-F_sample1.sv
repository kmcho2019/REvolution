module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // don't-care input, ignored
    output out
);

wire not_c = ~c;
wire not_b = ~b;

wire and_notc_a = not_c & a;       // Covers row c=0, a=1
wire or_term = not_b | a;          // Factored term for c=1 cases
wire and_c_or = c & or_term;       // Covers rows where c=1 and (b=0 or a=1)

assign out = and_notc_a | and_c_or;

endmodule