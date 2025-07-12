module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal SOP:
    // Output=1 for decimal 2(0010),7(0111),15(1111)
    // Decimal 2 = ~a & ~b & c & ~d
    // Decimals 7,15 have b=1,c=1,d=1, so (b & c & d)
    // The two terms cover all ones exactly, don't cares (3,8,11,12) can be ignored.
    wire sop_term1 = (~a) & (~b) & c & (~d);
    wire sop_term2 = b & c & d;

    assign out_sop = sop_term1 | sop_term2;

    // Minimal POS:
    // Zeros at 0,1,4,5,6,9,10,13,14
    // Using minterms and don't cares, the minimal product of sums is:
    // (a | b | ~c | ~d) & (a | ~b | c | d) & (~a | b | c | ~d)
    wire pos_term1 = (a | b | (~c) | (~d));
    wire pos_term2 = (a | (~b) | c | d);
    wire pos_term3 = ((~a) | b | c | (~d));

    assign out_pos = pos_term1 & pos_term2 & pos_term3;

endmodule