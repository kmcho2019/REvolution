module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // SOP implementation (correct - covers all minterms where output=1)
    assign out_sop = (~a & ~b & c & ~d) |  // 2
                    (~a & b & c & d) |    // 7
                    (a & b & c & d);       // 15

    // Correct POS implementation (covers all maxterms where output=0)
    assign out_pos = (a | b | c | d) &             // 0
                    (a | b | c | ~d) &            // 1
                    (a | ~b | c | d) &            // 4
                    (a | ~b | c | ~d) &           // 5
                    (a | ~b | ~c | d) &           // 6
                    (~a | b | c | ~d) &           // 9
                    (~a | b | ~c | d) &           // 10
                    (~a | ~b | c | ~d) &          // 13
                    (~a | ~b | ~c | d);           // 14

endmodule