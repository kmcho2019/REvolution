module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);

wire ab_high; // Temporary variable to hold the result of (a | b)
wire ab_low_cd_high; // Temporary variable to hold the result of ((~a) & (~b) & (c | d))

assign ab_high = (a | b);
assign ab_low_cd_high = ((~a) & (~b) & (c | d));
assign q = ab_high | ab_low_cd_high;

endmodule