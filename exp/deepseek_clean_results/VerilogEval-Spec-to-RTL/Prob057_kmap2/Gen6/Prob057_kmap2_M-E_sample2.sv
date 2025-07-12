module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Product terms covering all '1's in the K-map
wire term1 = ~a & ~b;                // ab=00 (except cd=11)
wire term2 = ~a & b & ~c & ~d;       // ab=01, cd=00
wire term3 = ~a & b & c & d;         // ab=01, cd=11
wire term4 = a & ~b & (~c | ~d);     // ab=10 (except cd=10)
wire term5 = a & b & (c | d);        // ab=11 (except cd=00)

// Final output is OR of all product terms
assign out = term1 | term2 | term3 | term4 | term5;

endmodule