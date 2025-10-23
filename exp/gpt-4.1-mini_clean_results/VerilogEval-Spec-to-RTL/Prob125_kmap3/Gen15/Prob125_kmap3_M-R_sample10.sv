module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // don't care input
    output out
);

// Intermediate partial terms
wire term1 = a & ~c;
wire term2 = c & ~b;
wire term3 = c & a;

// Output is OR of the partial terms
assign out = term1 | term2 | term3;

endmodule