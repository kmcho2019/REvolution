module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal SOP for out_sop = 1 at 2,7,15:
    // 2  = ~a & ~b & c & ~d
    // 7  = ~a & b & c & d
    // 15 = a & b & c & d
    assign out_sop = (~a & ~b & c & ~d)
                  | (~a &  b & c &  d)
                  | ( a &  b & c &  d);

    // Minimal POS for out_pos = 0 at 0,1,4,5,6,9,10,13,14:
    // Maxterms for these inputs:
    // (a + b + c + d)           // 0
    // (a + b + c + ~d)          // 1
    // (a + ~b + c + d)          // 4
    // (a + ~b + c + ~d)         // 5
    // (a + ~b + ~c + d)         // 6
    // (~a + b + c + ~d)         // 9
    // (~a + b + ~c + d)         // 10
    // (~a + ~b + c + ~d)        // 13
    // (~a + ~b + ~c + d)        // 14
    assign out_pos = 
          (a | b | c | d)
        & (a | b | c | ~d)
        & (a | ~b | c | d)
        & (a | ~b | c | ~d)
        & (a | ~b | ~c | d)
        & (~a | b | c | ~d)
        & (~a | b | ~c | d)
        & (~a | ~b | c | ~d)
        & (~a | ~b | ~c | d);

endmodule