module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum-of-Products implementation
    // Minterms: 2 (0010), 7 (0111), 15 (1111)
    assign out_sop = (~a & ~b & c & ~d) |  // 2
                     (~a & b & c & d) |   // 7
                     (a & b & c & d);     // 15

    // Product-of-Sums implementation
    // Maxterms: 0(0000),1(0001),4(0100),5(0101),6(0110),
    //           9(1001),10(1010),13(1101),14(1110)
    assign out_pos = (a | b | c | d) &         // Covers 0
                     (a | b | c | ~d) &        // Covers 1
                     (a | ~b | c | d) &        // Covers 4
                     (a | ~b | c | ~d) &      // Covers 5
                     (a | ~b | ~c | d) &       // Covers 6
                     (~a | b | c | ~d) &       // Covers 9
                     (~a | b | ~c | d) &       // Covers 10
                     (~a | ~b | c | ~d) &      // Covers 13
                     (~a | ~b | ~c | d);       // Covers 14

endmodule