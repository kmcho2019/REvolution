module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Define minterms for inputs combinations with an odd number of 1's:
    // Number of 1s in (a,b,c,d) is odd = 1 or 3
    // Minterms with exactly 1 bit set:
    wire m1 =  a & ~b & ~c & ~d;
    wire m2 = ~a &  b & ~c & ~d;
    wire m3 = ~a & ~b &  c & ~d;
    wire m4 = ~a & ~b & ~c &  d;

    // Minterms with exactly 3 bits set:
    wire m5 =  a &  b &  c & ~d;
    wire m6 =  a &  b & ~c &  d;
    wire m7 =  a & ~b &  c &  d;
    wire m8 = ~a &  b &  c &  d;

    // OR all minterms to produce parity output
    assign out = m1 | m2 | m3 | m4 | m5 | m6 | m7 | m8;

endmodule