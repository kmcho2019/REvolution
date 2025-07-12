module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Decode ab combinations (one-hot)
wire ab00 = ~a & ~b;
wire ab01 = ~a & b;
wire ab11 = a & b;
wire ab10 = a & ~b;

// Decode cd combinations (one-hot)
wire cd00 = ~c & ~d;
wire cd01 = ~c & d;
wire cd11 = c & d;
wire cd10 = c & ~d;

// Create intermediate terms for each K-map cell that outputs 0
wire term1 = cd11 & ab00;  // cd=11, ab=00
wire term2 = cd01 & ab01;  // cd=01, ab=01
wire term3 = cd01 & ab11;  // cd=01, ab=11
wire term4 = cd10 & ab11;  // cd=10, ab=11
wire term5 = cd10 & ab10;  // cd=10, ab=10
wire term6 = cd00 & ab11;  // cd=00, ab=11

// Final output is 1 unless any of the terms above are 1
assign out = ~(term1 | term2 | term3 | term4 | term5 | term6);

endmodule