module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Inputs order: a(MSB), b, c, d(LSB)
    // Output=1 for decimal inputs: 2(0010),7(0111),15(1111)
    // Output=0 for: 0,1,4,5,6,9,10,13,14
    // Don't-cares: 3,8,11,12

    // Minimal SOP (sum of minterms 2,7,15)
    assign out_sop =
        (~a & ~b &  c & ~d) |    // m2 = 0010
        (~a &  b &  c &  d) |    // m7 = 0111
        ( a &  b &  c &  d);     // m15= 1111

    // Minimal POS considering don't-cares 3,8,11,12:
    // Derived from Karnaugh map simplification
    // out_pos = (a + c + d) & (b + c + ~d) & (~a + ~b + ~c + d)
    assign out_pos =
        (a | c | d) &
        (b | c | ~d) &
        (~a | ~b | ~c | d);

endmodule