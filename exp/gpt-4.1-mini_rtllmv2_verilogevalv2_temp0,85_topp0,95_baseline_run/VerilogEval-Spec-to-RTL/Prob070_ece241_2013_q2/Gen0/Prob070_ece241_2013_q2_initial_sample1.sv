module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimal SOP expression for output=1:
// out_sop = a b c d + a' b c d + a' b' c d'
wire term1, term2, term3;

assign term1 = a & b & c & d;
assign term2 = (~a) & b & c & d;
assign term3 = (~a) & (~b) & c & (~d);

assign out_sop = term1 | term2 | term3;

// Minimal POS expression for output=1:
// out_pos = (a + d) (a' + c + d') (b + c' + d')
wire pos1, pos2, pos3;

assign pos1 = a | d;
assign pos2 = (~a) | c | (~d);
assign pos3 = b | (~c) | (~d);

assign out_pos = pos1 & pos2 & pos3;

endmodule