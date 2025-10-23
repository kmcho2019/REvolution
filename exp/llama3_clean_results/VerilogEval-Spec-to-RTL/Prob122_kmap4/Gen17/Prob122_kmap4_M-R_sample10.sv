module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

wire same_ab;
wire same_cd;
wire diff_cd;

assign same_ab = (a == b);
assign same_cd = (c == d);
assign diff_cd = (c!= d);
assign out = (same_ab && diff_cd) || (!same_ab && same_cd);

endmodule