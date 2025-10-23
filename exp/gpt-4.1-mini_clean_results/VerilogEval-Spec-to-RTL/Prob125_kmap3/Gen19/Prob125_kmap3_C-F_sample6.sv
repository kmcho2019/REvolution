module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // don't care, ignored
    output out
);

wire term1 = a & ~c;
wire term2 = c & a;
wire term3 = c & ~b;

assign out = term1 | term2 | term3;

endmodule