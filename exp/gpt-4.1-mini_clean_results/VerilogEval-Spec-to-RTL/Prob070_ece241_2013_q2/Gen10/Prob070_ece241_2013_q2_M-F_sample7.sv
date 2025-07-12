module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // out_sop = m2 + m7 + m15
    // m2  = ~a & ~b & c & ~d  (0010)
    // m7  = ~a & b & c & d    (0111)
    // m15 = a & b & c & d     (1111)
    assign out_sop = (~a & ~b & c & ~d) | (~a & b & c & d) | (a & b & c & d);

    // Minimal POS covering zeros at 0,1,4,5,6,9,10,13,14 and excluding 2,7,15, 
    // with don't-cares at 3,8,11,12:
    // out_pos = (a + b + ~c + d) & (a + ~b + c + ~d) & (~a + ~b + ~c + d) & (~a + ~b + c + ~d)
    assign out_pos = (a | b | ~c | d) & (a | ~b | c | ~d) & (~a | ~b | ~c | d) & (~a | ~b | c | ~d);

endmodule