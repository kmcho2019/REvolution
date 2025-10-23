module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum-of-products implementation with don't-care handling
    assign out_sop = (~a & ~b & c & ~d) |  // Pattern 2 (0010)
                     (~a & b & c & d) |    // Pattern 7 (0111)
                     (a & b & c & d);      // Pattern 15 (1111)
                     // Don't-care cases (3,8,11,12) default to 0

    // Product-of-sums implementation with don't-care handling
    assign out_pos = ~((~a & ~b & ~c & ~d) |  // Pattern 0 (0000)
                      (~a & ~b & ~c & d) |    // Pattern 1 (0001)
                      (~a & b & ~c & ~d) |    // Pattern 4 (0100)
                      (~a & b & ~c & d) |     // Pattern 5 (0101)
                      (~a & b & c & ~d) |     // Pattern 6 (0110)
                      (a & ~b & ~c & d) |     // Pattern 9 (1001)
                      (a & ~b & c & ~d) |     // Pattern 10 (1010)
                      (a & b & ~c & d) |      // Pattern 13 (1101)
                      (a & b & c & ~d));      // Pattern 14 (1110)
                      // Don't-care cases (3,8,11,12) default to 1

endmodule