module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

wire term1_sop, term2_sop, term3_sop;
wire term1_pos, term2_pos, term3_pos;

// SOP terms
assign term1_sop = a & c & d;
assign term2_sop = a & b & d;
assign term3_sop = a & b & (~c);

// out_sop = term1 + term2 + term3
assign out_sop = term1_sop | term2_sop | term3_sop;

// POS terms
// (a + b + c') = a | b | ~c
assign term1_pos = a | b | (~c);
// (a + b' + d) = a | ~b | d
assign term2_pos = a | (~b) | d;
// (a' + c + d) = ~a | c | d
assign term3_pos = (~a) | c | d;

// out_pos = term1 & term2 & term3
assign out_pos = term1_pos & term2_pos & term3_pos;

endmodule