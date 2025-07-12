module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Refactored Sum-of-products implementation
    assign out_sop = (b & c & d) |          // Covers 7 (0111) and 15 (1111)
                    (~a & ~b & c & ~d);     // Covers 2 (0010)

    // Refactored Product-of-sums implementation
    assign out_pos = (b | c | d) &          // Covers 0-6 cases
                    (~a | b | c) &          // Covers 9,10,13,14 cases
                    (a | ~b | ~d);          // Additional coverage

endmodule