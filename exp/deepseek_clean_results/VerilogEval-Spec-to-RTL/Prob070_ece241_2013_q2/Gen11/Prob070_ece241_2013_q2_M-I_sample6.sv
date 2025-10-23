module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum-of-products implementation
    // Covers all cases where output should be 1 (2,7,15)
    assign out_sop = (~a & ~b & c & ~d) |  // 2: 0010
                     (~a & b & c & d)   |   // 7: 0111
                     (a & b & c & d);       // 15: 1111

    // Product-of-sums implementation
    // Covers all cases where output should be 0
    assign out_pos = (a | b | c | d)    &   // M0: 0000
                     (a | b | c | ~d)   &   // M1: 0001
                     (a | ~b | c | d)  &    // M4: 0100
                     (a | ~b | c | ~d)  &    // M5: 0101
                     (a | ~b | ~c | d)  &    // M6: 0110
                     (~a | b | c | ~d) &    // M9: 1001
                     (~a | b | ~c | d)  &    // M10: 1010
                     (~a | ~b | c | ~d) &    // M13: 1101
                     (~a | ~b | ~c | d);     // M14: 1110

endmodule