module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal SOP expression (correct from before):
    // f = (c & d) + (~a & ~b & c & ~d)
    assign out_sop = (c & d) | (~a & ~b & c & ~d);

    // Corrected minimal POS expression (3 sums):
    // f = (a + b + ~c + d) & (a + ~b + ~c + ~d) & (~a + b + c + d)
    assign out_pos = (a | b | ~c | d) & (a | ~b | ~c | ~d) & (~a | b | c | d);

endmodule