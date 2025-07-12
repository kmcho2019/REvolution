module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // d is don't-care, ignored in logic
    output out
);

wire not_c = ~c;
wire not_b = ~b;

assign out = (c & not_b) | (not_c & a);

endmodule