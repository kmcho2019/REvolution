module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

wire na = ~a;
wire nb = ~b;
wire nc = ~c;
wire nd = ~d;

// ab signals (a = MSB, b = LSB)
wire ab_00 = na & nb; // 00
wire ab_01 = na & b;  // 01
wire ab_11 = a  & b;  // 11
wire ab_10 = a  & nb; // 10

// Each cd row from Karnaugh map using ab signals:

// cd=00 (c=0, d=0): ab=00(1),01(1),11(0),10(1)
wire cd_00 = ab_00 | ab_01 | ab_10;

// cd=01 (c=0, d=1): ab=00(1),01(0),11(0),10(1)
wire cd_01 = ab_00 | ab_10;

// cd=11 (c=1, d=1): ab=00(0),01(1),11(1),10(1)
wire cd_11 = ab_01 | ab_11 | ab_10;

// cd=10 (c=1, d=0): ab=00(1),01(1),11(0),10(0)
wire cd_10 = ab_00 | ab_01;

// Select output based on c,d inputs using one-hot encoding:
assign out = (nc & nd & cd_00) |
             (nc & d  & cd_01) |
             (c  & d  & cd_11) |
             (c  & nd & cd_10);

endmodule