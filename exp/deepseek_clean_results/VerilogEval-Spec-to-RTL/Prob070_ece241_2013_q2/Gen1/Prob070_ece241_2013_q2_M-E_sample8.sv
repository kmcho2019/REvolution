module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum-of-products implementation
    // Covers cases: 2 (0010), 7 (0111), 15 (1111)
    assign out_sop = (~a & b & ~c & ~d) |  // 2
                     (~a & b & c & d) |     // 7
                     (a & b & c & d);       // 15

    // Product-of-sums implementation
    // Equivalent to AND of OR terms for 0 cases, using don't cares for optimization
    assign out_pos = (a | c) &       // Covers most 0 cases
                     (b | d) &       // Covers remaining 0 cases
                     (~b | ~c);      // Final elimination

endmodule