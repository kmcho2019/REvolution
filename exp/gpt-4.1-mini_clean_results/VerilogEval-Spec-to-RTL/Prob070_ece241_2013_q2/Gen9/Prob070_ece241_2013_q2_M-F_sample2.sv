module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal SOP for out_sop:
    // out_sop = (~a & ~b & c & ~d) | (~a & b & c & d) | (a & b & c & d)
    wire term_2  = ~a & ~b & c & ~d;  // 2 -> 0 0 1 0
    wire term_7  = ~a &  b & c &  d;  // 7 -> 0 1 1 1
    wire term_15 =  a &  b & c &  d;  // 15-> 1 1 1 1

    assign out_sop = term_2 | term_7 | term_15;

    // Minimal POS for out_pos:
    // out_pos = (a + b + ~c + d) & (a + ~b + c + d) & (~a + b + c + ~d)
    wire clause1 = a | b | ~c | d;
    wire clause2 = a | ~b | c | d;
    wire clause3 = ~a | b | c | ~d;

    assign out_pos = clause1 & clause2 & clause3;

endmodule