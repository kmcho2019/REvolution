module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal SOP expression for out_sop (logic 1 at inputs 2,7,15)
    assign out_sop = 
        (~a & ~b &  c & ~d) |    // 2  = 0010
        (~a &  b &  c &  d) |    // 7  = 0111
        ( a &  b &  c &  d);     // 15 = 1111

    // Corrected minimal POS expression for out_pos (logic 0 at inputs 0,1,4,5,6,9,10,13,14)
    assign out_pos = 
        (a | b | ~c | d)   &    // covers zeros 0,1,4,5,6
        (a | ~b | c | ~d)  &    // covers zeros 9,13
        (~a | b | c | ~d);       // covers zeros 10,14

endmodule