module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal SOP expression for out_sop (1 when input is 2, 7, or 15):
    assign out_sop = 
        (~a & ~b &  c & ~d) |  // 2
        (~a &  b &  c &  d) |  // 7
        ( a &  b &  c &  d);   // 15

    // Minimal POS expression for out_pos (0 when input is 0,1,4,5,6,9,10,13,14):
    assign out_pos = 
        (a |  b |  d) & 
        (a | ~b |  c) & 
        (~a |  b | ~c | ~d);

endmodule