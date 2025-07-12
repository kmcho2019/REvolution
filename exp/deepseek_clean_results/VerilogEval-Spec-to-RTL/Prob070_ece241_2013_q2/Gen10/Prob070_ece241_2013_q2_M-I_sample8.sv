module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum-of-products (minimal form)
    assign out_sop = (~a & ~b & c & ~d) |  // 2
                     (~a & b & c & d) |    // 7
                     (a & b & c & d);      // 15

    // Product-of-sums (simplified form)
    assign out_pos = (a | b | c) &         // Covers 0,1,4,5,9,13
                     (a | c | d) &         // Covers 0,4,6,14
                     (a | ~b | c) &        // Covers 4,5,6
                     (~a | b | c) &        // Covers 9,10
                     (~a | c | d);         // Covers 10,13,14

endmodule