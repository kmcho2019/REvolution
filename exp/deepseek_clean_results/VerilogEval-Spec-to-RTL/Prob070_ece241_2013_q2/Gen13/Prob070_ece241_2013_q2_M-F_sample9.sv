module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Intermediate pattern detection signals
    wire pattern_2  = ~a & ~b &  c & ~d;  // 0010 (2)
    wire pattern_7  = ~a &  b &  c &  d;  // 0111 (7)
    wire pattern_15 =  a &  b &  c &  d;  // 1111 (15)

    // Sum of Products implementation (Σ(2,7,15))
    assign out_sop = pattern_2 | pattern_7 | pattern_15;

    // Product of Sums implementation (Π(0,1,4,5,6,9,10,13,14))
    // Implemented as inverted OR of all forbidden terms
    assign out_pos = ~(
        (~a & ~b & ~c & ~d) |  // 0
        (~a & ~b & ~c &  d) |  // 1
        (~a &  b & ~c & ~d) |  // 4
        (~a &  b & ~c &  d) |  // 5
        (~a &  b &  c & ~d) |  // 6
        ( a & ~b & ~c &  d) |  // 9
        ( a & ~b &  c & ~d) |  // 10
        ( a &  b & ~c &  d) |  // 13
        ( a &  b &  c & ~d)    // 14
    );

endmodule