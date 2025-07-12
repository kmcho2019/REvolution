module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum-of-products (unchanged - correct implementation)
    assign out_sop = (~a & ~b & c & ~d) |  // 2
                     (~a & b & c & d) |     // 7
                     (a & b & c & d);       // 15

    // Product-of-sums (corrected implementation)
    // Maxterms for all false cases (0,1,4,5,6,9,10,13,14)
    assign out_pos = (a | b | c | d) &         // 0 (0000)
                     (a | b | c | ~d) &        // 1 (0001)
                     (a | ~b | c | d) &        // 4 (0100)
                     (a | ~b | c | ~d) &       // 5 (0101)
                     (a | ~b | ~c | d) &       // 6 (0110)
                     (~a | b | c | ~d) &       // 9 (1001)
                     (~a | b | ~c | d) &       // 10 (1010)
                     (~a | ~b | c | ~d) &      // 13 (1101)
                     (~a | ~b | ~c | d);       // 14 (1110)

endmodule