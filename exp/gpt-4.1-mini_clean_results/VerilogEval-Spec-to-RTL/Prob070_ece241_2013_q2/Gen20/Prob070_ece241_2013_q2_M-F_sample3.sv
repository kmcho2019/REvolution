module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Negated inputs for clarity
    wire na = ~a;
    wire nb = ~b;
    wire nc = ~c;
    wire nd = ~d;

    // Minimal Sum-of-Products (SOP) for outputs = 1 at decimal 2,7,15:
    // 2  = 0 0 1 0 -> ~a & ~b & c & ~d
    // 7  = 0 1 1 1 -> ~a &  b & c &  d
    // 15 = 1 1 1 1 ->  a &  b & c &  d
    assign out_sop = (na & nb &  c & nd)
                   | (na &  b &  c &  d)
                   | ( a &  b &  c &  d);

    // Product of maxterms for zeros at decimal: 0,1,4,5,6,9,10,13,14
    // Each maxterm corresponds to input bits:
    // M0  (0000):  ( a +  b +  c +  d )
    // M1  (0001):  ( a +  b +  c + ~d )
    // M4  (0100):  ( a + ~b +  c +  d )
    // M5  (0101):  ( a + ~b +  c + ~d )
    // M6  (0110):  ( a + ~b + ~c +  d )
    // M9  (1001):  (~a +  b +  c + ~d )
    // M10 (1010):  (~a +  b + ~c +  d )
    // M13 (1101):  (~a + ~b +  c + ~d )
    // M14 (1110):  (~a + ~b + ~c +  d )
    assign out_pos =
        ( a |  b |  c |  d ) &
        ( a |  b |  c | nd ) &
        ( a | nb |  c |  d ) &
        ( a | nb |  c | nd ) &
        ( a | nb | nc |  d ) &
        (na |  b |  c | nd ) &
        (na |  b | nc |  d ) &
        (na | nb |  c | nd ) &
        (na | nb | nc |  d );

endmodule