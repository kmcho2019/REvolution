module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    wire ab_00, ab_01, ab_11, ab_10;
    wire cd_00, cd_01, cd_11, cd_10;
    wire out_ab_00, out_ab_01, out_ab_11, out_ab_10;

    assign ab_00 = ~a & ~b;
    assign ab_01 = ~a & b;
    assign ab_11 = a & b;
    assign ab_10 = a & ~b;

    assign cd_00 = ~c & ~d;
    assign cd_01 = ~c & d;
    assign cd_11 = c & d;
    assign cd_10 = c & ~d;

    assign out_ab_00 = cd_00 | cd_01 | cd_10;
    assign out_ab_01 = cd_00 | cd_11 | cd_10;
    assign out_ab_11 = cd_01 | cd_11 | cd_10;
    assign out_ab_10 = cd_00 | cd_01;

    assign out = (ab_00 & out_ab_00) | (ab_01 & out_ab_01) | (ab_11 & out_ab_11) | (ab_10 & out_ab_10);

endmodule