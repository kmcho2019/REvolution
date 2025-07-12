module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal SOP expression for out_sop (covers 2,7,15)
    assign out_sop = 
        (a & b & c & d) |            // 15
        (~a & b & c & d) |           // 7
        (~a & ~b & c & ~d);          // 2

    // Minimal POS expression for out_pos (covers zeros)
    assign out_pos = 
        (a | ~b | ~c | d) &          // maxterm excluding 2 and 7
        (a | b | c | ~d);            // maxterm excluding 15

endmodule