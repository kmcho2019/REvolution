module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum-of-products form (unchanged optimal implementation)
    assign out_sop = (c & d) | (~a & ~b & c & ~d);

    // Refactored product-of-sums form
    // Grouped similar terms and leveraged don't-care conditions
    assign out_pos = (a | b | c) &                 // Covers 0000,0001,0100,0101
                     (a | ~b | d) &                 // Covers 0100,0101,0110
                     (a | ~b | ~c) &                // Covers 0110
                     (~a | b | ~d) &                // Covers 1001,1010
                     (~a | ~b | ~d) &               // Covers 1101,1110
                     (~a | ~c | d);                 // Covers 1010,1110

endmodule