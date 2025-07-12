module TopModule (
    input  a,  // MSB
    input  b,
    input  c,
    input  d,  // LSB
    output out_sop,
    output out_pos
);

// Minimal SOP terms:
// 1) Minterm 2: ~a & ~b & c & ~d
// 2) Group covering 7 (0111) and dc at 3 (0011): ~b & c & d
// 3) Minterm 15: a & b & c & d

wire term_2    = (~a) & (~b) & c & (~d);
wire term_7_3  = (~b) & c & d;
wire term_15   = a & b & c & d;

assign out_sop = term_2 | term_7_3 | term_15;

// Minimal POS terms:
// (a + b + ~c + ~d)(a + ~b + c + d)(~a + ~b + c + ~d)

wire pos_term1 = a | b | (~c) | (~d);
wire pos_term2 = a | (~b) | c | d;
wire pos_term3 = (~a) | (~b) | c | (~d);

assign out_pos = pos_term1 & pos_term2 & pos_term3;

endmodule