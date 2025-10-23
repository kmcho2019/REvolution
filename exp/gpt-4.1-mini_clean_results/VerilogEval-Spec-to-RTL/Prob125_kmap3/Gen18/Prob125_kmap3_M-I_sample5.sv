module TopModule(
    input a,
    input b,
    input c,
    input d, // don't care, ignored
    output out
);

wire not_c = ~c;
wire not_b = ~b;

wire term1 = not_c & a;
wire term2 = c & (not_b | a);

assign out = term1 | term2;

endmodule