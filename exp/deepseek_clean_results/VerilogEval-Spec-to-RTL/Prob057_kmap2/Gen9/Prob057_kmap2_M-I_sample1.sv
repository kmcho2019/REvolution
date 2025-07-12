module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Product-of-Sums implementation derived from K-map zeros
assign out = (c | d | ~a | ~b) &  // cd=11, ab=00
             (c | ~d | ~a | b) &   // cd=10, ab=11
             (~c | d | a | ~b) &   // cd=01, ab=11
             (~c | ~d | a | b);    // cd=00, ab=11

endmodule