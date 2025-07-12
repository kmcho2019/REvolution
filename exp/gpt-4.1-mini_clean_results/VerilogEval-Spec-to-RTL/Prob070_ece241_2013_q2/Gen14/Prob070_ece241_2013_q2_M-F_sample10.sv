module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal SOP (sum of products) for outputs=1 at 2,7,15 considering don't-cares:
    // Minterms:
    //  2 = ~a & ~b & c & ~d
    //  7 = ~a & b & c & d
    // 15 =  a & b & c & d
    // Simplified SOP:
    // out_sop = (b & c & d) | (~a & ~b & c & ~d)
    assign out_sop = (b & c & d) | (~a & ~b & c & ~d);

    // Minimal POS (product of sums) for zeros at 0,1,4,5,6,9,10,13,14 with don't-cares 3,8,11,12:
    // out_pos = (a + c + d) & (b + c + ~d) & (~a + ~b + ~c + d)
    assign out_pos = (a | c | d) & (b | c | ~d) & (~a | ~b | ~c | d);

endmodule