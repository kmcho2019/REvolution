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

// Output is the sum of all minterms for which Karnaugh map is 1
assign out = 
    // cd=00 row (c=0,d=0): ab=00(1),01(1),10(1)
    (nc & nd & na & nb) | // ab=00
    (nc & nd & na &  b) | // ab=01
    (nc & nd &  a & nb) | // ab=10

    // cd=01 row (c=0,d=1): ab=00(1),10(1)
    (nc &  d & na & nb) | // ab=00
    (nc &  d &  a & nb) | // ab=10

    // cd=11 row (c=1,d=1): ab=01(1),11(1),10(1)
    ( c &  d & na &  b) | // ab=01
    ( c &  d &  a &  b) | // ab=11
    ( c &  d &  a & nb) | // ab=10

    // cd=10 row (c=1,d=0): ab=00(1),01(1)
    ( c & nd & na & nb) | // ab=00
    ( c & nd & na &  b);  // ab=01

endmodule