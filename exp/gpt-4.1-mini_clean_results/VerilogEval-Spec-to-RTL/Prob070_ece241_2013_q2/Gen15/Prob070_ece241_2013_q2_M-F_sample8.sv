module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // SOP: 1 for 2(0010),7(0111),15(1111)
    wire m2  = (~a) & (~b) & c & (~d);
    wire m7  = (~a) & b & c & d;
    wire m15 = a & b & c & d;

    assign out_sop = m2 | m7 | m15;

    // POS: zeros at 0,1,4,5,6,9,10,13,14
    // Maxterms for zeros (sum terms equal to 0 for zeros):
    // 0 (0000): (a + b + c + d)
    // 1 (0001): (a + b + c + ~d)
    // 4 (0100): (a + ~b + c + d)
    // 5 (0101): (a + ~b + c + ~d)
    // 6 (0110): (a + ~b + ~c + d)
    // 9 (1001): (~a + b + c + ~d)
    // 10(1010): (~a + b + ~c + d)
    // 13(1101): (~a + ~b + c + ~d)
    // 14(1110): (~a + ~b + ~c + d)
    // The minimal POS after simplification:
    wire M0 = a | b | c | d;
    wire M1 = a | b | c | (~d);
    wire M4 = a | (~b) | c | d;
    wire M5 = a | (~b) | c | (~d);
    wire M6 = a | (~b) | (~c) | d;
    wire M9 = (~a) | b | c | (~d);
    wire M10= (~a) | b | (~c) | d;
    wire M13= (~a) | (~b) | c | (~d);
    wire M14= (~a) | (~b) | (~c) | d;

    // Combine all maxterms for zeros
    assign out_pos = M0 & M1 & M4 & M5 & M6 & M9 & M10 & M13 & M14;

endmodule