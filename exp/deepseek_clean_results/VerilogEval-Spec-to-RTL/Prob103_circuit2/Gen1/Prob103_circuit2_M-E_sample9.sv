module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Minterms where q=1
    wire m0 = ~a & ~b & ~c & ~d;  // 0000
    wire m1 = ~a & ~b &  c &  d;  // 0011
    wire m2 = ~a &  b & ~c &  d;  // 0101
    wire m3 = ~a &  b &  c & ~d;  // 0110
    wire m4 =  a & ~b & ~c &  d;  // 1001
    wire m5 =  a & ~b &  c & ~d;  // 1010
    wire m6 =  a &  b &  c &  d;  // 1111

    assign q = m0 | m1 | m2 | m3 | m4 | m5 | m6;

endmodule