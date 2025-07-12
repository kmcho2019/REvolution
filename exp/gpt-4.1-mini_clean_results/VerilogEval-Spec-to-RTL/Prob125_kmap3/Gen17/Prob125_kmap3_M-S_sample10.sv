module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // don't care, unused
    output out
);

wire not_b = ~b;

assign out = a | (c & not_b);

endmodule