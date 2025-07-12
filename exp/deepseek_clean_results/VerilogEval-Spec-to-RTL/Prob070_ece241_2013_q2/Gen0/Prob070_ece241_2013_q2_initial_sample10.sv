module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum-of-products implementation (OR of minterms)
    assign out_sop = (~a & ~b & c & ~d) |  // 2
                     (~a & b & c & d) |    // 7
                     (a & b & c & d);      // 15

    // Product-of-sums implementation (AND of maxterms)
    assign out_pos = (a | b | ~c | d) &    // Complement of 2
                     (~a | b | c | d) &    // Complement of 7
                     (~a | ~b | ~c | ~d);  // Complement of 15

endmodule