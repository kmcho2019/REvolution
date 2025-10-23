module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

// Invert inputs once
wire na = ~a;
wire nb = ~b;
wire nc = ~c;
wire nd = ~d;

// Minterms where output is 1
wire m0  = nc & nd & na & nb; // 0000
wire m1  = nc & nd & na & b;  // 0001
wire m2  = nc & nd & a & nb;  // 0010
wire m3  = nc & d  & na & nb; // 0100
wire m4  = nc & d  & a  & nb; // 0110
wire m5  = c  & nd & na & nb; // 1000
wire m6  = c  & nd & na & b;  // 1001
wire m7  = c  & nd & a  & b;  // 1011
wire m8  = c  & d  & na & b;  // 1101
wire m9  = c  & d  & a  & nb; // 1110
wire m10 = c  & d  & a  & b;  // 1111

assign out = m0 | m1 | m2 | m3 | m4 | m5 | m6 | m7 | m8 | m9 | m10;

endmodule