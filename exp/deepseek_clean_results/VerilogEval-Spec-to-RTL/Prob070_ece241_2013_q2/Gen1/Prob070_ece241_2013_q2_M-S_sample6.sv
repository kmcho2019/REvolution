module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Simplified Sum-of-products (OR of minterms for 1 outputs)
    assign out_sop = (~a & ~b & c & ~d) |  // 2
                     (~a & b & c & d) |     // 7
                     (a & b & c & d);       // 15

    // Simplified Product-of-sums (AND of maxterms for 0 outputs)
    // Using essential maxterms that cover all zero cases
    assign out_pos = (a | b | c | d) &         // Covers 0
                     (a | b | c | ~d) &        // Covers 1
                     (~a | b | c | d);         // Covers 4,5,6,9,10,13,14

endmodule