module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Optimized Sum of Products
    assign out_sop = (~a & ~b & c & ~d) | (b & c & d);

    // Optimized Product of Sums
    assign out_pos = c & (a | ~b | d) & (a | b | ~d) & (~a | b | d) & (~a | ~b | ~d);

endmodule