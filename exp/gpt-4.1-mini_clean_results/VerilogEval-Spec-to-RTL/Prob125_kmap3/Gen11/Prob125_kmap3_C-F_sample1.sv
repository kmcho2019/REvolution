module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // don't care, ignored
    output out
);

wire not_c = ~c;
wire not_b = ~b;

assign out = (not_c & a) | (c & (not_b | a));

endmodule