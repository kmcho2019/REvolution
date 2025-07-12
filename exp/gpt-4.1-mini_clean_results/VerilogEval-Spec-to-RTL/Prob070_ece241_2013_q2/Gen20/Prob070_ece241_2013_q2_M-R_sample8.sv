module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal SOP expression for out_sop:
    // out_sop = b & d & (~a + c)
    assign out_sop = b & d & (~a | c);

    // Minimal POS expression for out_pos:
    // out_pos = (a + b + c + ~d) & (a + ~b + c + d)
    assign out_pos = (a | b | c | ~d) & (a | ~b | c | d);

endmodule