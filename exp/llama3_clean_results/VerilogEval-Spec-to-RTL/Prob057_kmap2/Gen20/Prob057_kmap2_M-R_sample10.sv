module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

wire ab_not_11; // ab is not 11
wire cd_00_ab_not_11; // cd is 00 and ab is not 11
wire cd_01_ab_00_or_10; // cd is 01 and ab is 00 or 10
wire cd_11_ab_not_00; // cd is 11 and ab is not 00
wire cd_10_ab_00_or_01; // cd is 10 and ab is 00 or 01

assign ab_not_11 = ~(a & b);
assign cd_00_ab_not_11 = (~c & ~d) & ab_not_11;
assign cd_01_ab_00_or_10 = (~c & d) & ((~a & ~b) | (a & ~b));
assign cd_11_ab_not_00 = (c & d) & ~(~a & ~b);
assign cd_10_ab_00_or_01 = (c & ~d) & ((~a & ~b) | (~a & b));

assign out = cd_00_ab_not_11 | cd_01_ab_00_or_10 | cd_11_ab_not_00 | cd_10_ab_00_or_01;

endmodule