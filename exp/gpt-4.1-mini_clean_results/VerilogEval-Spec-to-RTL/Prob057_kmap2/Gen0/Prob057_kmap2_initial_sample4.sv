module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out =
    (~c & ~d & ~a & ~b) | // m0
    (~c & ~d & ~a &  b) | // m1
    (~c & ~d &  a & ~b) | // m2
    (~c &  d & ~a & ~b) | // m4
    (~c &  d &  a & ~b) | // m6
    ( c & ~d & ~a & ~b) | // m8
    ( c & ~d & ~a &  b) | // m9
    ( c &  d & ~a &  b) | // m13
    ( c &  d &  a & ~b) | // m14
    ( c &  d &  a &  b);  // m15

endmodule