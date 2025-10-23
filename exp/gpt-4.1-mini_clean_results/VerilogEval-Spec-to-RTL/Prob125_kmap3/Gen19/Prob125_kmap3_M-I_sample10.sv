module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // don't care, ignored
    output out
);

wire not_b = ~b;
wire not_c = ~c;
wire c_or_a = not_b | a;

// Factored logic: out = (a & ~c) | (c & (~b | a))
assign out = (a & not_c) | (c & c_or_a);

endmodule