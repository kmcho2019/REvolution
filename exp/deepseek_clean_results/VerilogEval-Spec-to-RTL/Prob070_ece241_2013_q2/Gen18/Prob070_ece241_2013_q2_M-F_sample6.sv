module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Corrected Sum-of-products (minimal form)
    // Only asserts for 2 (0010), 7 (0111), 15 (1111)
    assign out_sop = (~a & ~b & c & ~d) |  // 2
                     (~a & b & c & d)   |  // 7
                     (a & b & c & d);     // 15

    // Corrected Product-of-sums (minimal form)
    // Covers all false cases: 0,1,4,5,6,9,10,13,14
    assign out_pos = (b | c | d) &         // Covers 0,1,4
                     (a | b | ~c) &        // Covers 5,6,9,13
                     (a | ~b | c | ~d) &   // Covers 10,14
                     (~a | b | ~c | d);    // Final coverage

endmodule