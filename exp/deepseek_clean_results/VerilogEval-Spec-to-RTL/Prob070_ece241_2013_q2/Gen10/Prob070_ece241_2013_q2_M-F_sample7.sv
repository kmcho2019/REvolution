module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum-of-products (verified correct)
    assign out_sop = (~a & ~b & c & ~d) |  // 2
                     (~a & b & c & d) |    // 7
                     (a & b & c & d);      // 15

    // Corrected Product-of-sums
    assign out_pos = (a | b | ~c | d) &
                     (a | ~b | ~c | ~d) &
                     (~a | b | ~c | d) &
                     (~a | ~b | ~c | ~d);

endmodule