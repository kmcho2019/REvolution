module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // don't care, ignored
    output out
);

wire term1; // a & ~c
wire term2; // c & ~b
wire term3; // c & a

assign term1 = a & ~c;
assign term2 = c & ~b;
assign term3 = c & a;

assign out = term1 | term2 | term3;

endmodule