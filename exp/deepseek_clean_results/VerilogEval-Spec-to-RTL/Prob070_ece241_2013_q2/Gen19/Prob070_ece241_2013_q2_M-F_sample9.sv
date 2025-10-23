module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Optimized SOP implementation using don't-cares
    assign out_sop = (~a & ~b & c) |       // 001- (covers 2 and don't-care 3)
                    (~a & b & c & d) |    // 7
                    (a & b & c & d);      // 15

    // Optimized POS implementation using don't-cares
    assign out_pos = (b | c | d) &        // -000 (covers 0 and don't-care 8)
                    (b | c) &             // -00- (covers 1 and don't-care 9)
                    (a | c | d) &         // -100 (covers 4 and don't-care 12)
                    (a | c) &            // -10- (covers 5 and don't-care 13)
                    (a | ~b | ~c | d) &   // 6
                    (~a | b | ~c | d) &   // 10
                    (~a | ~b | ~c | d);   // 14

endmodule