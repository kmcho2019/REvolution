module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal SOP for outputs=1 (2,7,15)
    // out_sop = (~a & ~b & c & ~d) | (b & c & d)
    assign out_sop = 
        (~a & ~b &  c & ~d) |   // decimal 2
        (     b &  c &  d);     // decimals 7 and 15 combined

    // Minimal POS for outputs=0 (0,1,4,5,6,9,10,13,14)
    // out_pos = (a + c + d) & (a + ~b + d) & (~a + b + ~c)
    assign out_pos = 
        (a | c | d) & 
        (a | ~b | d) & 
        (~a | b | ~c);

endmodule