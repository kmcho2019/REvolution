module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // don't care
    output out
);

// Decode ab into one-hot signals (ab are two bits)
// ab codes: 00, 01, 10, 11
wire ab_00 = ~a & ~b;
wire ab_01 = ~a &  b;
wire ab_10 =  a & ~b;
wire ab_11 =  a &  b;

// Decode cd into one-hot signals (cd are two bits)
wire cd_00 = ~c & ~d;
wire cd_01 = ~c &  d;
wire cd_10 =  c & ~d;
wire cd_11 =  c &  d;

// From the Karnaugh map, output=1 for these ab/cd pairs:
// Rows (cd) / Cols (ab):
// cd\ab:  01  00  10  11
// 00      d    0   1   1
// 01      0    0   d   d
// 11      0    1   1   1
// 10      0    1   1   1

// Translate to active combinations (output=1):
// cd=00(0), ab=10(2) -> cd_00 & ab_10
// cd=00(0), ab=11(3) -> cd_00 & ab_11
// cd=11(3), ab=00(0) -> cd_11 & ab_00
// cd=11(3), ab=10(2) -> cd_11 & ab_10
// cd=11(3), ab=11(3) -> cd_11 & ab_11
// cd=10(2), ab=00(0) -> cd_10 & ab_00
// cd=10(2), ab=10(2) -> cd_10 & ab_10
// cd=10(2), ab=11(3) -> cd_10 & ab_11

wire term1 = cd_00 & ab_10;
wire term2 = cd_00 & ab_11;
wire term3 = cd_11 & ab_00;
wire term4 = cd_11 & ab_10;
wire term5 = cd_11 & ab_11;
wire term6 = cd_10 & ab_00;
wire term7 = cd_10 & ab_10;
wire term8 = cd_10 & ab_11;

assign out = term1 | term2 | term3 | term4 | term5 | term6 | term7 | term8;

endmodule