module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = 
    (~a & ~b & ~c & ~d) | // m0
    (~a &  b & ~c & ~d) | // m1
     (a & ~b & ~c & ~d) | // m2
    (~a & ~b & ~c &  d) | // m4
     (a & ~b & ~c &  d) | // m6
    (~a & ~b &  c & ~d) | // m8
    (~a &  b &  c & ~d) | // m9
    (~a &  b &  c &  d) | // m13
     (a & ~b &  c &  d) | // m14
     (a &  b &  c &  d);  // m15

endmodule