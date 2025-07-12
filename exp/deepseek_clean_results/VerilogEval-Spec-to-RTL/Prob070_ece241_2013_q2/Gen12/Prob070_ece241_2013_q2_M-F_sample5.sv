module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Minimal Sum-of-products implementation
    // Using don't-care conditions for optimization
    assign out_sop = (a & b & c & d) |      // 15: 1111
                     (b & c & d) |          // 7: 0111 (and don't-care 3:0011)
                     (~a & ~b & c & ~d);     // 2: 0010

    // Minimal Product-of-sums implementation
    // Using don't-care conditions for optimization
    assign out_pos = (b | c | d) &          // Covers 0000,0001,0100,0101,0110
                     (~a | b | c) &         // Covers 1001,1010,1101,1110
                     (a | ~b | ~d);         // Additional term for minimal coverage

endmodule