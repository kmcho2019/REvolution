module TopModule (
    input  a, b, c, d,
    output out_sop,
    output out_pos
);

    // Sum of Products - more compact form
    assign out_sop = (~a & c & (~b ^ d)) |  // Covers 2 (0010) and 7 (0111)
                     (a & b & c & d);        // 15 (1111)

    // Product of Sums - better organized with grouping
    assign out_pos = (a | b | c) &                  // Covers 0,1,4,5,6
                    (a | ~b | c) &                  // Covers 4,5,6,9,10
                    (a | ~b | ~c | d) &             // 6
                    (~a | b | (c ^ d)) &            // Covers 9,10
                    (~a | ~b | (c ^ d));            // Covers 13,14

endmodule