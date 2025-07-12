module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

    wire na = ~a;
    wire nb = ~b;
    wire nc = ~c;
    wire nd = ~d;

    assign out = 
        (na & nb & nc & nd) |  // m0
        (na &  b & nc & nd) |  // m1
        ( a & nb & nc & nd) |  // m2
        (na & nb & nc &  d) |  // m4
        ( a & nb & nc &  d) |  // m6
        (na & nb &  c & nd) |  // m8
        (na &  b &  c & nd) |  // m9
        (na &  b &  c &  d) |  // m13
        ( a & nb &  c &  d) |  // m14
        ( a &  b &  c &  d);   // m15

endmodule