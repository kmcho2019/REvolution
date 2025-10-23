module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

wire ab_00, ab_01, ab_11, ab_10;
wire cd_00, cd_01, cd_11, cd_10;

// Implement logic for ab
assign ab_00 = ~a & ~b;
assign ab_01 = ~a & b;
assign ab_11 = a & b;
assign ab_10 = a & ~b;

// Implement logic for cd
assign cd_00 = ~c & ~d;
assign cd_01 = ~c & d;
assign cd_11 = c & d;
assign cd_10 = c & ~d;

// Use Karnaugh map values to assign out
assign out = (ab_00 & cd_00) | (ab_00 & cd_01) | (ab_00 & cd_10) |
             (ab_01 & cd_00) | (ab_01 & cd_11) | (ab_01 & cd_10) |
             (ab_11 & cd_01) | (ab_11 & cd_11) | (ab_11 & cd_10) |
             (ab_10 & cd_00) | (ab_10 & cd_01);

endmodule