module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum-of-Products (same as before - already minimal)
    assign out_sop = (~a & ~b & c & ~d) |  // 2
                    (~a & b & c & d) |     // 7
                    (a & b & c & d);       // 15

    // Product-of-Sums (simplified to 3 terms)
    assign out_pos = (b | c | d) &                // Covers 0,1,4,5,6,8
                     (a | ~b | ~c | d) &          // Covers 4,5,6,12,13,14
                     (~a | b | c | ~d);           // Covers 9,10

endmodule