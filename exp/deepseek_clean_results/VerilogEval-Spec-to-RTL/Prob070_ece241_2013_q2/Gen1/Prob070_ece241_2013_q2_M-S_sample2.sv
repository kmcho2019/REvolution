module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum-of-products implementation (same as before - no better simplification found)
    assign out_sop = (~a & ~b & c & ~d) | (~a & b & c & d) | (a & b & c & d);

    // Product-of-sums implementation (simplified using don't-cares)
    assign out_pos = (a | c) & (b | d) & (b | c);

endmodule