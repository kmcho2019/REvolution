module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);

wire c_or_d;
wire p, r;

assign c_or_d = c | d;
assign p = a & c_or_d;
assign r = b & c_or_d;
assign q = p | r;

endmodule