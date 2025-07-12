module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

wire term1_sop, term2_sop;
wire term1_pos, term2_pos;

// Minimal SOP:
// out = (b & c & d) + (~a & ~b & c)
assign term1_sop = b & c & d;
assign term2_sop = (~a) & (~b) & c;
assign out_sop = term1_sop | term2_sop;

// Minimal POS:
// out = (a + b + ~c + ~d) & (a + ~b + ~c + d)
assign term1_pos = a | b | (~c) | (~d);
assign term2_pos = a | (~b) | (~c) | d;
assign out_pos = term1_pos & term2_pos;

endmodule