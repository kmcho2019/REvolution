module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal SOP: out_sop = b c d + a' b' c d'
    assign out_sop = (b & c & d) | (~a & ~b & c & ~d);

    // Minimal POS: out_pos = (b' + c' + d') (a + b + c' + d)
    assign out_pos = ( (~b) | (~c) | (~d) ) & ( a | b | (~c) | d );

endmodule