module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimal Sum-of-Products (SOP) form for out_sop:
// out_sop = a b c d + ~a b c d + ~a ~b c ~d

wire term1_sop = a & b & c & d;
wire term2_sop = (~a) & b & c & d;
wire term3_sop = (~a) & (~b) & c & (~d);

assign out_sop = term1_sop | term2_sop | term3_sop;

// Minimal Product-of-Sums (POS) form for out_pos:
// out_pos = (a + b + ~c + d) * (a + ~b + c + d) * (~a + ~b + c + ~d)

wire clause1_pos = a | b | (~c) | d;
wire clause2_pos = a | (~b) | c | d;
wire clause3_pos = (~a) | (~b) | c | (~d);

assign out_pos = clause1_pos & clause2_pos & clause3_pos;

endmodule