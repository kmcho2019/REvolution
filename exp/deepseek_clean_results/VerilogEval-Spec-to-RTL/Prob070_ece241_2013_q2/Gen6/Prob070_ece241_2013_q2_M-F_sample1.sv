module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Optimized Sum-of-products implementation using don't-cares
    assign out_sop = (~a & ~b & c & ~d) |  // 2 (0010)
                     (b & c & d);           // Combined 7 (0111) and 15 (1111)

    // Optimized Product-of-sums implementation using don't-cares
    assign out_pos = (a | b | ~c | d) &     // POS term for ~2
                     (~b | ~c | ~d);        // Combined POS terms for ~7 and ~15

endmodule