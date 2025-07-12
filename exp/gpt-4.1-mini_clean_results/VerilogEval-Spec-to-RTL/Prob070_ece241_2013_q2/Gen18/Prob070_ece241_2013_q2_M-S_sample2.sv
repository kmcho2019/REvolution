module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);
    // Minimal SOP (sum of minterms for 2,7,15):
    assign out_sop = (~a & ~b &  c & ~d)  // 2
                   | (~a &  b &  c &  d)  // 7
                   | ( a &  b &  c &  d); // 15

    // Minimal POS (product of sums for zeros 0,1,4,5,6,9,10,13,14)
    assign out_pos = (a | b | ~c)
                   & (a | ~b | d)
                   & (~a | b | c | ~d);

endmodule