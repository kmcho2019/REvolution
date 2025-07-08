module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

wire term1_sop, term2_sop, term3_sop;
wire term1_pos, term2_pos, term3_pos;

// Minimal SOP terms
assign term1_sop = b & (~c) & d;
assign term2_sop = a & b & c;
assign term3_sop = a & b & d;
assign out_sop = term1_sop | term2_sop | term3_sop;

// Minimal POS terms
assign term1_pos = a | b | c | d;
assign term2_pos = a | b | (~c) | (~d);
assign term3_pos = a | (~b) | c | d;
assign out_pos = term1_pos & term2_pos & term3_pos;

endmodule