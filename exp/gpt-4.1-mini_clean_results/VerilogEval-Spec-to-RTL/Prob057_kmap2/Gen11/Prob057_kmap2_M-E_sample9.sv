module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Minterms where output=1 according to Karnaugh map:
// cd=00, ab=00 => c=0, d=0, a=0, b=0  -> ~c & ~d & ~a & ~b
// cd=00, ab=01 => c=0, d=0, a=0, b=1  -> ~c & ~d & ~a & b
// cd=00, ab=10 => c=0, d=0, a=1, b=0  -> ~c & ~d & a & ~b
// cd=01, ab=00 => c=0, d=1, a=0, b=0  -> ~c & d & ~a & ~b
// cd=01, ab=10 => c=0, d=1, a=1, b=0  -> ~c & d & a & ~b
// cd=10, ab=00 => c=1, d=0, a=0, b=0  -> c & ~d & ~a & ~b
// cd=10, ab=01 => c=1, d=0, a=0, b=1  -> c & ~d & ~a & b
// cd=11, ab=01 => c=1, d=1, a=0, b=1  -> c & d & ~a & b
// cd=11, ab=10 => c=1, d=1, a=1, b=0  -> c & d & a & ~b
// cd=11, ab=11 => c=1, d=1, a=1, b=1  -> c & d & a & b

assign out = 
    (~c & ~d & ~a & ~b) |
    (~c & ~d & ~a &  b) |
    (~c & ~d &  a & ~b) |
    (~c &  d & ~a & ~b) |
    (~c &  d &  a & ~b) |
    ( c & ~d & ~a & ~b) |
    ( c & ~d & ~a &  b) |
    ( c &  d & ~a &  b) |
    ( c &  d &  a & ~b) |
    ( c &  d &  a &  b);

endmodule