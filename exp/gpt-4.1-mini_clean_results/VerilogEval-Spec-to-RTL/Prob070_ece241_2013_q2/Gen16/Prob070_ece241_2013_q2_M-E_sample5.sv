module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal SOP for out_sop = 1 only when input decimal is 2,7,15
    // Truth table (inputs abc d):
    // 2  = 0 0 1 0
    // 7  = 0 1 1 1
    // 15 = 1 1 1 1
    // Minimal SOP derived (by K-map or boolean algebra):
    // out_sop = (a & b & c & d) + (~a & b & c & d) + (~a & ~b & c & ~d)

    wire term1 = a & b & c & d;        // 15
    wire term2 = ~a & b & c & d;       // 7
    wire term3 = ~a & ~b & c & ~d;     // 2
    assign out_sop = term1 | term2 | term3;

    // Minimal POS for out_pos (output 1 for zeros of out_sop):
    // zeros = 0,1,4,5,6,9,10,13,14
    // Minimal POS (derived via K-map or Boolean simplification):
    // out_pos = (a + b + ~c + d) & (~a + b + ~c + ~d) & (~a + ~b + ~c + d)

    wire sum1 = a | b | ~c | d;
    wire sum2 = ~a | b | ~c | ~d;
    wire sum3 = ~a | ~b | ~c | d;
    assign out_pos = sum1 & sum2 & sum3;

endmodule