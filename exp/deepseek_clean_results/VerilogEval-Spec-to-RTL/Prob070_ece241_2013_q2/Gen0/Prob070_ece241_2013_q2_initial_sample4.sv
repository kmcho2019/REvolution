module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum-of-Products implementation
    assign out_sop = (~a & ~b & c & ~d) |  // 2 (0010)
                     (~a & b & c & d) |     // 7 (0111)
                     (a & b & c & d);       // 15 (1111)

    // Product-of-Sums implementation
    assign out_pos = (~a | ~b | ~c | d) &  // M0 (0000)
                     (~a | b | c | ~d) &   // M1 (0001)
                     (a | ~b | ~c | d) &   // M4 (0100)
                     (a | ~b | c | ~d) &   // M5 (0101)
                     (a | b | c | ~d);     // M6 (0110)

endmodule