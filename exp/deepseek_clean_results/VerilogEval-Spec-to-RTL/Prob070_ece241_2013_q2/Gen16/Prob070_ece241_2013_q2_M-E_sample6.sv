module TopModule (
    input  a, b, c, d,
    output out_sop,
    output out_pos
);

    // Intermediate signals for pattern matching
    wire pattern_2  = ~a & ~b &  c & ~d;  // 0010
    wire pattern_7  = ~a &  b &  c &  d;  // 0111
    wire pattern_15 =  a &  b &  c &  d;  // 1111

    // SOP implementation (direct minterm matching)
    assign out_sop = pattern_2 | pattern_7 | pattern_15;

    // POS implementation (complement of SOP plus explicit 0-cases)
    wire out_pos_temp = ~(pattern_2 | pattern_7 | pattern_15);

    // Additional gating for explicit 0-output cases
    assign out_pos = out_pos_temp & 
                    ~(~a & ~b & ~c & ~d) &  // 0
                    ~(~a & ~b & ~c &  d) &  // 1
                    ~(~a &  b & ~c & ~d) &  // 4
                    ~(~a &  b & ~c &  d) &  // 5
                    ~(~a &  b &  c & ~d) &  // 6
                    ~( a & ~b & ~c &  d) &  // 9
                    ~( a & ~b &  c & ~d) &  // 10
                    ~( a &  b & ~c &  d) &  // 13
                    ~( a &  b &  c & ~d);   // 14

endmodule