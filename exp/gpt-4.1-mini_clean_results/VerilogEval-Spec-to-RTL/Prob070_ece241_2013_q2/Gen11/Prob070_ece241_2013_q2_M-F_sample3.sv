module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal SOP for out_sop:
    // 1) (b & c & d): covers inputs with b=1,c=1,d=1 => decimal 7(0111) and 15(1111)
    // 2) (~a & ~b & c & ~d): covers decimal 2 (0010) exactly
    wire sop_term1 = b & c & d;
    wire sop_term2 = (~a) & (~b) & c & (~d);

    assign out_sop = sop_term1 | sop_term2;

    // Minimal POS for out_pos:
    // Using zeros minterms coverage:
    // out_pos = (a | b | ~c | ~d) & (a | ~b | c | d) & (~a | b | c | ~d)
    wire pos_term1 = (a | b | (~c) | (~d));
    wire pos_term2 = (a | (~b) | c | d);
    wire pos_term3 = ((~a) | b | c | (~d));

    assign out_pos = pos_term1 & pos_term2 & pos_term3;

endmodule