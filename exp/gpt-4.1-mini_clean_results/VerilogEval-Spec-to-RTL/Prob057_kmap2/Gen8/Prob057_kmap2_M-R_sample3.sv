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

// List all minterms corresponding to 1's in the K-map

wire m0  = nc & nd & na & nb; // cd=00 ab=00
wire m1  = nc & nd & na & b;  // cd=00 ab=01
wire m2  = nc & nd & a  & nb; // cd=00 ab=10
wire m3  = nc & nd & a  & b;  // cd=00 ab=11 is 0, so omitted

wire m4  = nc & d  & na & nb; // cd=01 ab=00
wire m5  = nc & d  & na & b;  // cd=01 ab=01 is 0, omitted
wire m6  = nc & d  & a  & nb; // cd=01 ab=10
wire m7  = nc & d  & a  & b;  // cd=01 ab=11 is 0, omitted

wire m8  = c  & d  & na & nb; // cd=11 ab=00 is 0, omitted
wire m9  = c  & d  & na & b;  // cd=11 ab=01
wire m10 = c  & d  & a  & nb; // cd=11 ab=10
wire m11 = c  & d  & a  & b;  // cd=11 ab=11

wire m12 = c  & nd & na & nb; // cd=10 ab=00
wire m13 = c  & nd & na & b;  // cd=10 ab=01
wire m14 = c  & nd & a  & nb; // cd=10 ab=10 is 0, omitted
wire m15 = c  & nd & a  & b;  // cd=10 ab=11 is 0, omitted

// OR all minterms that correspond to 1 in the table
assign out = m0 | m1 | m2 | m4 | m6 | m9 | m10 | m11 | m12 | m13;

endmodule