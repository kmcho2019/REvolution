module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimal SOP covering 2 (0010), 7 (0111), and 15 (1111):
// out_sop = (~a & ~b & c & ~d) | (~a & b & c & d) | (a & b & c & d)
assign out_sop = (~a & ~b &  c & ~d) |
                 (~a &  b &  c &  d) |
                 ( a &  b &  c &  d);

// Minimal POS (derived from zeros and simplified):
// out_pos = (a + b + ~c + d) & (a + ~b + c + d) & (~a + b + c + d)
assign out_pos = (a | b | ~c | d) &
                 (a | ~b |  c | d) &
                 (~a | b |  c | d);

endmodule