module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal SOP expression for out_sop = 1 when input is 2,7,15
    // out_sop = c·((~a & ~b & ~d) + (b & d))
    wire term1 = ~a & ~b & ~d & c;
    wire term2 = b & c & d;
    assign out_sop = term1 | term2;

    // Minimal POS expression for out_pos = 0 at 0,1,4,5,6,9,10,13,14:
    // out_pos = (a + b + c + d)·(a + b + ~c + d)·(a + ~b + c + d)·(a + ~b + c + ~d)
    assign out_pos = (a | b | c | d)
                   & (a | b | ~c | d)
                   & (a | ~b | c | d)
                   & (a | ~b | c | ~d);

endmodule