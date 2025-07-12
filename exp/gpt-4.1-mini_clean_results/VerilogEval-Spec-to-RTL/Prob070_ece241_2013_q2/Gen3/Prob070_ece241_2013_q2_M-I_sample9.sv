module TopModule (
    input  a,  // MSB
    input  b,
    input  c,
    input  d,  // LSB
    output out_sop,
    output out_pos
);

// Minimal SOP terms derived:
// For outputs = 1 at decimal 2 (0010), 7 (0111), 15 (1111), and with don't cares at 3,8,11,12
// The SOP terms cover these minterms and leverage don't cares for simplification
// out_sop = (~a & ~b & c & ~d) + (b & c & d)

// Define SOP terms explicitly
wire term_sop_2 = (~a) & (~b) & c & (~d); // minterm for 2 (0010)
wire term_sop_7_15 = b & c & d;           // covers minterms 7 (0111) and 15 (1111)

// Combine SOP terms
assign out_sop = term_sop_2 | term_sop_7_15;

// Minimal POS terms:
// (a + b + d)(a + c + d)(~a + ~b + c + ~d)
// These cover all zeros and exclude the ones

wire pos_term1 = a | b | d;
wire pos_term2 = a | c | d;
wire pos_term3 = (~a) | (~b) | c | (~d);

assign out_pos = pos_term1 & pos_term2 & pos_term3;

endmodule