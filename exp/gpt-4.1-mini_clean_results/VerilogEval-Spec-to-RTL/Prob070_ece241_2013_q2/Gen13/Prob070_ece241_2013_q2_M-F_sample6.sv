module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal SOP expression for out_sop (1 for 2,7,15)
    assign out_sop = 
        (~a & ~b & c & ~d) |        // 2  = 0010
        (~a &  b & c &  d) |        // 7  = 0111
        ( a &  b & c &  d);         // 15 = 1111

    // Minimal POS expression for out_pos (0 for 0,1,4,5,6,9,10,13,14)
    assign out_pos = 
        (a | b | ~c | ~d) &         // covers 0,1,4,5,6 zeros
        (a | ~b | c | d)  &         // covers 9,13 zeros
        (~a | b | c | ~d);           // covers 10,14 zeros

endmodule