module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);

wire ab, ac, ad, bc, bd, cd;

assign ab = a & b;
assign ac = a & c;
assign ad = a & d;
assign bc = b & c;
assign bd = b & d;
assign cd = c & d;

assign q = ab | ac | ad | bc | bd | cd;

endmodule