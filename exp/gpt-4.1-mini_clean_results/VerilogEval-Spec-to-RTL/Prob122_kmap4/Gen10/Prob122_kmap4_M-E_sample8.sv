module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Invert inputs for easier minterm definition
    wire na = ~a;
    wire nb = ~b;
    wire nc = ~c;
    wire nd = ~d;

    // Define each minterm corresponding to output=1 in the K-map
    wire m0 = na & nb & nc &  d; // 0001
    wire m1 = na & nb &  c & nd; // 0010
    wire m2 = na &  b & nc & nd; // 0100
    wire m3 = na &  b &  c &  d; // 0111
    wire m4 =  a & nb & nc & nd; // 1000
    wire m5 =  a & nb &  c &  d; // 1011
    wire m6 =  a &  b & nc &  d; // 1101
    wire m7 =  a &  b &  c & nd; // 1110

    // OR all minterms to produce output
    assign out = m0 | m1 | m2 | m3 | m4 | m5 | m6 | m7;
endmodule