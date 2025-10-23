module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Intermediate signals for pattern detection
    wire pattern_2  = ~a & ~b &  c & ~d;  // 0010
    wire pattern_7  = ~a &  b &  c &  d;  // 0111
    wire pattern_15 =  a &  b &  c &  d;  // 1111

    // SOP implementation - direct OR of valid patterns
    assign out_sop = pattern_2 | pattern_7 | pattern_15;

    // POS implementation using NOR of invalid patterns
    // Implemented by detecting "not any invalid pattern"
    wire invalid_0  = ~a & ~b & ~c & ~d;
    wire invalid_1  = ~a & ~b & ~c &  d;
    wire invalid_4  = ~a &  b & ~c & ~d;
    wire invalid_5  = ~a &  b & ~c &  d;
    wire invalid_6  = ~a &  b &  c & ~d;
    wire invalid_9  =  a & ~b & ~c &  d;
    wire invalid_10 =  a & ~b &  c & ~d;
    wire invalid_13 =  a &  b & ~c &  d;
    wire invalid_14 =  a &  b &  c & ~d;

    // POS is 1 when none of the invalid patterns are active
    assign out_pos = ~(invalid_0 | invalid_1 | invalid_4 | invalid_5 |
                      invalid_6 | invalid_9 | invalid_10 | invalid_13 | invalid_14);

endmodule