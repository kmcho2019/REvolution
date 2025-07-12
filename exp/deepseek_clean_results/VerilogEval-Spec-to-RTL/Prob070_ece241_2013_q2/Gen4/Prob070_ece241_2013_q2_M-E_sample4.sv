module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Optimized Sum-of-products using don't-cares
    assign out_sop = (~a & ~b & c) | (b & c & d);

    // Optimized Product-of-sums using don't-cares
    assign out_pos = (a | c) & (~b | ~c | ~d);

endmodule