module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Output is 0 in these specific cases, else 1
assign out = ~(
    (~c & ~d & a & b) |  // cd=00, ab=11
    (~c & d & ~a & b) |  // cd=01, ab=01
    (~c & d & a & b) |   // cd=01, ab=11
    (c & ~d & a & b) |   // cd=10, ab=11
    (c & ~d & a & ~b) |  // cd=10, ab=10
    (c & d & ~a & ~b)    // cd=11, ab=00
);

endmodule