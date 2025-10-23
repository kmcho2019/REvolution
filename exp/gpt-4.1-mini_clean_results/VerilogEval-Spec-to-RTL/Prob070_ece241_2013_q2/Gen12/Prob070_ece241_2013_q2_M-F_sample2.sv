module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimal SOP for out_sop:
// out_sop = (a & b & c) | (a & b & d) | (~a & b & ~c & d)
assign out_sop = (a & b & c) | (a & b & d) | (~a & b & ~c & d);

// Minimal POS for out_pos:
// out_pos = (a + ~b + c + ~d) & (a + b + ~c + d) & (~a + b + c + d)
assign out_pos = (a | ~b | c | ~d) & (a | b | ~c | d) & (~a | b | c | d);

endmodule