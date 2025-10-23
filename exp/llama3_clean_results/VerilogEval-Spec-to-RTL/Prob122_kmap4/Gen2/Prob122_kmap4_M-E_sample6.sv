module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

wire cd_00_ab_01;
wire cd_01_ab_00_11;
wire cd_10_ab_00_11;
wire cd_11_ab_01_10;

assign cd_00_ab_01 = (~c & ~d & ~a & b);
assign cd_01_ab_00_11 = (~c & d & ((~a & ~b) | (a & b)));
assign cd_10_ab_00_11 = (c & ~d & ((~a & ~b) | (a & b)));
assign cd_11_ab_01_10 = (c & d & ((~a & b) | (a & ~b)));

assign out = (cd_00_ab_01 | cd_01_ab_00_11 | cd_10_ab_00_11 | cd_11_ab_01_10);

endmodule