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

// Enumerate minterms corresponding to the Karnaugh map '1' cells

wire m0 = nc & nd & na & nb;   // cd=00 ab=00
wire m1 = nc & nd & na &  b;   // cd=00 ab=01
wire m3 = nc & nd &  a & nb;   // cd=00 ab=10

wire m4 = nc &  d & na & nb;   // cd=01 ab=00
wire m7 = nc &  d &  a & nb;   // cd=01 ab=10

wire m9 =  c & nd & na & nb;   // cd=11 ab=01
wire m10 = c & nd & na &  b;   // cd=11 ab=11
wire m11 = c & nd &  a & nb;   // cd=11 ab=10
wire m8 =  c &  d & na & nb;   // cd=11 ab=00

// Combine all minterms with OR
assign out = m0 | m1 | m3 | m4 | m7 | m8 | m9 | m10 | m11;

endmodule