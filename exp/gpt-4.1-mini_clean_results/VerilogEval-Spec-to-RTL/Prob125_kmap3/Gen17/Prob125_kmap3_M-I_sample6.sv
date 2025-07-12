module TopModule(
    input a,
    input b,
    input c,
    input d, // don't care, ignored
    output out
);

wire not_c = ~c;
wire not_b = ~b;
wire or_term = not_b | a;

assign out = (not_c & a) | (c & or_term);

endmodule