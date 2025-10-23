module TopModule(
    input a,
    input b,
    input c,
    input d, // don't care, unused
    output out
);

wire not_c = ~c;
wire not_b = ~b;

wire term1 = not_c & a;          // covers (c=0 and a=1)
wire term2 = c & (not_b | a);   // covers (c=1 and (a=1 or b=0))

assign out = term1 | term2;

endmodule