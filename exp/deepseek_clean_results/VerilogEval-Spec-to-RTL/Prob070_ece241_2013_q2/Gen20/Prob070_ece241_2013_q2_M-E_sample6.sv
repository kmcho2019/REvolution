module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum-of-products implementation with optimal don't-care utilization
    // Patterns 2 (0010), 7 (0111), 15 (1111)
    wire pattern_2 = ~a & ~b & c & ~d;
    wire pattern_7 = ~a & b & c & d;
    wire pattern_15 = a & b & c & d;
    
    assign out_sop = pattern_2 | pattern_7 | pattern_15;

    // Product-of-sums implementation with optimal don't-care utilization
    // Invert of invalid patterns: 0,1,4,5,6,9,10,13,14
    wire invalid_0 = ~a & ~b & ~c & ~d;
    wire invalid_1 = ~a & ~b & ~c & d;
    wire invalid_4 = ~a & b & ~c & ~d;
    wire invalid_5 = ~a & b & ~c & d;
    wire invalid_6 = ~a & b & c & ~d;
    wire invalid_9 = a & ~b & ~c & d;
    wire invalid_10 = a & ~b & c & ~d;
    wire invalid_13 = a & b & ~c & d;
    wire invalid_14 = a & b & c & ~d;
    
    assign out_pos = ~(invalid_0 | invalid_1 | invalid_4 | invalid_5 |
                      invalid_6 | invalid_9 | invalid_10 | invalid_13 | invalid_14);

endmodule