module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Pack inputs into a 4-bit vector for clarity: {a,b,c,d}
wire [3:0] inputs;
assign inputs = {a, b, c, d};

// Decode each input bit for clarity
wire na = ~a;
wire nb = ~b;
wire nc = ~c;
wire nd = ~d;

// Minimal SOP terms:
// term_sop1 = b & c & d
// term_sop2 = ~a & ~b & c & ~d
wire term_sop1 = b & c & d;
wire term_sop2 = na & nb & c & nd;

assign out_sop = term_sop1 | term_sop2;

// Minimal POS terms:
// (a + b + ~c + ~d) & (a + ~b + ~c + d) & (~a + ~b + c + d)
wire pos_term1 = a | b | nc | nd;
wire pos_term2 = a | nb | nc | d;
wire pos_term3 = na | nb | c | d;

assign out_pos = pos_term1 & pos_term2 & pos_term3;

endmodule