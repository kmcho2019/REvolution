module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Output is 0 in these cases:
// cd=00 & ab=11
// cd=01 & (ab=01 | ab=11)
// cd=10 & (ab=11 | ab=10)
// cd=11 & ab=00

assign out = ~(
    (~c & ~d & a & b) |                 // cd=00, ab=11
    (~c & d & ((~a & b) | (a & b))) |   // cd=01, ab=01 or 11
    (c & ~d & ((a & b) | (a & ~b))) |   // cd=10, ab=11 or 10
    (c & d & ~a & ~b)                   // cd=11, ab=00
);

endmodule