module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Intermediate pattern detection signals
    wire pattern_2  = ~a & ~b &  c & ~d;  // 0010
    wire pattern_7  = ~a &  b &  c &  d;  // 0111
    wire pattern_15 =  a &  b &  c &  d;  // 1111
    wire common_abc = a & b & c;          // abc=111 (covers 7 and 15)

    // Sum of Products implementation
    assign out_sop = pattern_2 | pattern_7 | pattern_15;

    // Product of Sums implementation
    // Each term represents a forbidden input combination where output=0
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