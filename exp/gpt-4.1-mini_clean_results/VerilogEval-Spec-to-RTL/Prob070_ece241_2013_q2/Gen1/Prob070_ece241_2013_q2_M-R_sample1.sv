module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

wire [3:0] in_vec;
assign in_vec = {a, b, c, d};

// Minimal SOP terms for out_sop
wire term_15, term_7, term_2;

assign term_15 = a & b & c & d;      // 1111 (15)
assign term_7  = (~a) & b & c & d;   // 0111 (7)
assign term_2  = (~a) & (~b) & c & (~d); // 0010 (2)

assign out_sop = term_15 | term_7 | term_2;

// Minimal POS terms for out_pos
wire pos1, pos2, pos3;

// POS terms correspond to the simplified product-of-sums covering all zeros
assign pos1 = a | (~b) | (~c) | d;
assign pos2 = a | b | (~c) | (~d);
assign pos3 = (~a) | b | (~c) | d;

assign out_pos = pos1 & pos2 & pos3;

endmodule