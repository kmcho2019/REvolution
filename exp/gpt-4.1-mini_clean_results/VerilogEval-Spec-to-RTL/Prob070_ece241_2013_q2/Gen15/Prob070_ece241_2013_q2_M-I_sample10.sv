module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);
    // Minimal SOP for outputs=1 (2,7,15) with don't cares (3,8,11,12)
    assign out_sop =
        (~a & ~b &  c & ~d) |  // minterm 2 (0010)
        (     b &  c &  d) |   // minterm 7 (0111)
        (     a &  b &  c &  d);// minterm 15(1111)

    // Minimal POS covering all zeros (0,1,4,5,6,9,10,13,14)
    assign out_pos = 
        ( a |  b |  d) & 
        ( a | ~b |  c | ~d);

endmodule