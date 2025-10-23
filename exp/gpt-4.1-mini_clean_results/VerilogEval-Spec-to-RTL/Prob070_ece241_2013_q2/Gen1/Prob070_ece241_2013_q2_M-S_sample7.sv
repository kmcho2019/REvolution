module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimal SOP: out_sop = a'b' c d' + b c d
assign out_sop = (~a & ~b & c & ~d) | (b & c & d);

// Minimal POS: out_pos = (a + b + ~d) (a + ~b + c + d) (~a + b + c + d)
assign out_pos = (a | b | ~d) & (a | ~b | c | d) & (~a | b | c | d);

endmodule