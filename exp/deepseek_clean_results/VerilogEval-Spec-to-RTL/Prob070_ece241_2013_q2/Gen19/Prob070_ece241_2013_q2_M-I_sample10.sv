module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Minimal Sum-of-Products form
    // Using don't-cares to simplify:
    // - Combine 2 (0010) and 3 (0011) -> ~a & ~b & c
    // - 7 (0111) and 15 (1111) remain separate
    assign out_sop = (~a & ~b & c) |  // Covers 2 and 3 (don't-care)
                    (~a & b & c & d) |  // 7
                    (a & b & c & d);   // 15

    // Minimal Product-of-Sums form
    // Using don't-cares to simplify the inverted terms:
    // - Combine multiple false cases using common patterns
    wire out_pos_n;  // Temporary inverted output
    assign out_pos_n = (~a & ~b & ~c) |  // Covers 0,1
                      (~a & b & ~c) |    // Covers 4,5
                      (~a & b & c & ~d) | // 6
                      (a & ~b & ~c & d) | // 9
                      (a & ~b & c & ~d) | // 10
                      (a & b & ~c & d) |  // 13
                      (a & b & c & ~d);   // 14
    assign out_pos = ~out_pos_n;

endmodule