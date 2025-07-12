module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Simplified Sum-of-products
    assign out_sop = (~a & ~b & c & ~d) |  // 2
                     (b & c & d);          // 7 or 15

    // Simplified Product-of-sums
    assign out_pos = (a | b | ~c | d) &    // Covers most false cases
                     (~b | ~c | ~d);       // Covers remaining false cases

endmodule