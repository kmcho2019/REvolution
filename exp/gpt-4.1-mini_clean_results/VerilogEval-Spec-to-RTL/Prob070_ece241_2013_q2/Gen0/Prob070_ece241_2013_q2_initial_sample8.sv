module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

wire term1, term2, term3;

// Minimal SOP terms for out_sop
assign term1 = a & b & c & d;
assign term2 = (~a) & b & c & d;
assign term3 = (~a) & (~b) & c & (~d);

assign out_sop = term1 | term2 | term3;

// Minimal POS terms for out_pos
wire pos1, pos2, pos3;

assign pos1 = a | (~b) | (~c) | d;
assign pos2 = a | b | (~c) | (~d);
assign pos3 = (~a) | b | (~c) | d;

assign out_pos = pos1 & pos2 & pos3;

endmodule