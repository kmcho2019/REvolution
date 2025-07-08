module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

wire term1_sop, term2_sop;
wire term1_pos, term2_pos, term3_pos;

// Sum of products (SOP) minimal expression:
// out_sop = a b d + b c d'
assign term1_sop = a & b & d;
assign term2_sop = b & c & (~d);
assign out_sop = term1_sop | term2_sop;

// Product of sums (POS) minimal expression:
// out_pos = (a + b + c' + d)(a + b' + c + d)(a' + b + c + d')
assign term1_pos = a | b | (~c) | d;
assign term2_pos = a | (~b) | c | d;
assign term3_pos = (~a) | b | c | (~d);
assign out_pos = term1_pos & term2_pos & term3_pos;

endmodule