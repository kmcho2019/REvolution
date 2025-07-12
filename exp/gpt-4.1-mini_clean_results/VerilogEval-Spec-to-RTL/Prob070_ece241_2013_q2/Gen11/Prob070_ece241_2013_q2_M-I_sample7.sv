module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // SOP: output=1 for decimal 2(0010),7(0111),15(1111)
    assign out_sop =
        (~a & ~b &  c & ~d) |    // m2
        (~a &  b &  c &  d) |    // m7
        ( a &  b &  c &  d);     // m15

    // Correct minimal POS by De Morgan's of SOP:
    // out_pos = ~(out_sop)
    // = (~m2) & (~m7) & (~m15)
    // ~m2 = a + b + ~c + d
    // ~m7 = a + ~b + ~c + ~d
    // ~m15= ~a + ~b + ~c + ~d

    assign out_pos =
        (a | b | ~c | d) &
        (a | ~b | ~c | ~d) &
        (~a | ~b | ~c | ~d);

endmodule