module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

wire same_cd; // c and d are the same
wire diff_ab; // a and b are different
wire diff_cd; // c and d are different
wire same_ab; // a and b are the same

assign same_cd = (c == d);
assign diff_ab = (a!= b);
assign diff_cd = (c!= d);
assign same_ab = (a == b);

assign out = (same_cd & diff_ab) | (diff_cd & same_ab);

endmodule