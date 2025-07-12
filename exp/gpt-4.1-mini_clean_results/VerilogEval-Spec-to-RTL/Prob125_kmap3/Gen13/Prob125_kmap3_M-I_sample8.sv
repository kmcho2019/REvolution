module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // d is don't-care, ignored in logic
    output out
);

wire not_b = ~b;
wire not_c = ~c;

wire term1 = c & (a | not_b);
wire term2 = a & not_c;

assign out = term1 | term2;

endmodule