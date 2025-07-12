module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Direct implementation of K-map zeros as product terms
wire term1 =  a &  b &  c &  d;  // ab=11, cd=11
wire term2 = ~a &  b & ~c &  d;  // ab=01, cd=01
wire term3 =  a &  b & ~c &  d;  // ab=11, cd=01
wire term4 =  a &  b &  c & ~d;  // ab=11, cd=10
wire term5 =  a & ~b &  c & ~d;  // ab=10, cd=10
wire term6 = ~a & ~b &  c &  d;  // ab=00, cd=11

// Output is 1 unless any zero-term is active
assign out = ~(term1 | term2 | term3 | term4 | term5 | term6);

endmodule