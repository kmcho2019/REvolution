module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal SOP (sum of products) with don't-cares considered
    // out_sop = (~a & c & ~d) | (b & c & d)
    assign out_sop = (~a &  c & ~d) | (b & c & d);

    // Minimal POS (product of sums) with don't-cares considered
    // out_pos = (a + ~c + d) & (a + b + ~d)
    assign out_pos = (a | ~c | d) & (a | b | ~d);

endmodule