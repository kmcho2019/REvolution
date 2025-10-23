module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // More precise SOP implementation
    assign out_sop = (~a & ~b & c) |      // Covers only 2 (0010) and don't-care 3 (0011)
                    (~a & b & c & d) |   // Exactly matches 7 (0111)
                    (a & b & c & d);     // Exactly matches 15 (1111)

    // More accurate POS implementation
    assign out_pos = (a | b | c | d) &       // 0000 (0)
                    (a | b | c | ~d) &       // 0001 (1)
                    (a | ~b | c) &           // 0100 (4) and 0101 (5)
                    (a | ~b | ~c) &          // 0110 (6)
                    (~a | b | d) &           // 1001 (9) and 1010 (10)
                    (~a | ~b | d);           // 1101 (13) and 1110 (14)

endmodule