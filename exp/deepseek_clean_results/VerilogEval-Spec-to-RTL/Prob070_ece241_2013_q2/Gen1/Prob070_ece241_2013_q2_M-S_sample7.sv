module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum-of-products implementation (already minimal)
    assign out_sop = (~a & ~b & c & ~d) |  // 2 (0010)
                     (~a & b & c & d)   |  // 7 (0111)
                     (a & b & c & d);      // 15 (1111)

    // Product-of-sums implementation (complement of SOP)
    assign out_pos = ~((~a & ~b & c & ~d) |  // Complement of SOP terms
                       (~a & b & c & d)   |
                       (a & b & c & d));

endmodule