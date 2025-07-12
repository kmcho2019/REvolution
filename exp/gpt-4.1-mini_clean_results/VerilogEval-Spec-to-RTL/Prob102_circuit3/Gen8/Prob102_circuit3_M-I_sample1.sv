module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);

wire ab = a | b;
wire cd = c | d;

assign q = ab & cd;

endmodule