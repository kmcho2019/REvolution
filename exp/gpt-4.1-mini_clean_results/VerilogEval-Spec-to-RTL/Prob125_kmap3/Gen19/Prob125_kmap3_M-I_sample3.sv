module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // don't care, ignored
    output out
);

wire term2; // c & ~b

assign term2 = c & ~b;
assign out = a | term2;

endmodule