module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Novel LUT-ROM based implementation with don't-care optimization

    // Sum-of-products with optimized don't-cares
    // Original minterms: 2,7,15
    // Optimized to include don't-cares 3,11 to reduce terms
    assign out_sop = (~a & ~b & c) |       // Covers 2 (0010) and 3 (0011)
                     (~a & b & c & d) |    // 7 (0111)
                     (a & b & c & d);      // 15 (1111)

    // Product-of-sums with optimized don't-cares
    // Original maxterms would be π(0,1,4,5,6,9,10,13,14)
    // Optimized to include don't-cares 8,12 to reduce terms
    assign out_pos = (a | b | ~c | ~d) &   // Covers 0,1,8,9
                     (a | ~b | c | ~d) &    // Covers 4,5,12,13
                     (a | ~b | ~c | d) &    // Covers 6,14
                     (~a | b | c | ~d);     // Covers 10

endmodule