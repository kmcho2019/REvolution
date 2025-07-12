module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Output is 0 in these simplified cases:
// cd=00 & ab=11
// cd=01 & b
// cd=10 & a
// cd=11 & ab=00

assign out = ~(
    (~c & ~d & a & b) |  // cd=00, ab=11
    (~c & d & b) |       // cd=01, b=1
    (c & ~d & a) |       // cd=10, a=1
    (c & d & ~a & ~b)    // cd=11, ab=00
);

endmodule