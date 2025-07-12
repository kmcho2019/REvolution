module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Simplified Sum-of-Products
    assign out_sop = (~a & ~b & c & ~d) | (b & c & d);

    // Simplified Product-of-Sums
    assign out_pos = c & (b | d) & (a | b | ~d);

endmodule