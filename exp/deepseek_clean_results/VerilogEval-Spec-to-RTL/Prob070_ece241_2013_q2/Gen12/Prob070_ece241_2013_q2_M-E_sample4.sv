module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Optimized Sum-of-products implementation
    // Using don't-care conditions for minimization
    assign out_sop = (~b & c & ~d) |  // Covers 2 (0010) and can expand to don't-cares
                    (b & c & d)    |  // Covers 7 (0111)
                    (a & b & c);       // Covers 15 (1111) and can expand to don't-cares

    // Optimized Product-of-sums implementation
    // Using don't-care conditions for minimization
    assign out_pos = (b | c | d) &    // Covers M0,M1,M4,M5,M6,M9,M13
                     (~b | c | ~d) &   // Covers M10,M14
                     (a | c);          // Covers remaining cases

endmodule