module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal SOP expression for out_sop (output 1 at inputs 2,7,15)
    assign out_sop = (~a & ~b & c) | (c & d);

    // out_pos is simply the complement of out_sop, representing minimal POS form
    assign out_pos = ~out_sop;

endmodule