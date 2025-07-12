module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal SOP for out_sop:
    // out_sop = (b & c & d) | (~a & ~b & c)
    // Covers outputs=1 for decimal 7 and 15 (b,c,d=1),
    // and decimal 2 (~a & ~b & c)
    wire sop_term1 = b & c & d;           // covers 7 (0111) and 15 (1111)
    wire sop_term2 = (~a) & (~b) & c;     // covers 2 (0010)

    assign out_sop = sop_term1 | sop_term2;

    // Minimal POS for out_pos:
    // out_pos = (a + b + c + d) & (a + ~b + c + ~d) & (~a + b + ~c + d)
    wire pos_term1 = (a | b | c | d);
    wire pos_term2 = (a | (~b) | c | (~d));
    wire pos_term3 = ((~a) | b | (~c) | d);

    assign out_pos = pos_term1 & pos_term2 & pos_term3;

endmodule