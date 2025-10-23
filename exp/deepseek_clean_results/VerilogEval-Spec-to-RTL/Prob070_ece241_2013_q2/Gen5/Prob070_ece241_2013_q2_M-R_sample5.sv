module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum-of-products form (correct implementation)
    assign out_sop = (c & d) | (~a & ~b & c & ~d);

    // Product-of-sums form (properly derived)
    // Each factor blocks one invalid input combination
    assign out_pos = (a | b | c | d) &             // blocks 0000 (0)
                     (a | b | c | ~d) &             // blocks 0001 (1)
                     (a | ~b | c | d) &             // blocks 0100 (4)
                     (a | ~b | c | ~d) &            // blocks 0101 (5)
                     (a | ~b | ~c | d) &            // blocks 0110 (6)
                     (~a | b | c | ~d) &            // blocks 1001 (9)
                     (~a | b | ~c | d) &            // blocks 1010 (10)
                     (~a | ~b | c | ~d) &           // blocks 1101 (13)
                     (~a | ~b | ~c | d);            // blocks 1110 (14)

endmodule