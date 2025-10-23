module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

// Sum-of-Products form
// Minterms corresponding to 2 (0010), 7 (0111), and 15 (1111)
assign out_sop = (~a & b & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Product-of-Sums form using De Morgan's laws and complement
// First, let's define the maxterms corresponding to excluded numbers
wire m0, m1, m4, m5, m6, m9, m10, m13, m14;

assign m0 = ~a & ~b & ~c & ~d;  // 0000
assign m1 = ~a & ~b & ~c & d;   // 0001
assign m4 = ~a & b & ~c & ~d;   // 0100
assign m5 = ~a & b & ~c & d;    // 0101
assign m6 = ~a & b & c & ~d;    // 0110
assign m9 = a & ~b & c & d;     // 1001
assign m10 = a & b & ~c & ~d;   // 1010
assign m13 = a & b & c & ~d;    // 1101
assign m14 = a & b & ~c & d;    // 1110

// The SOP form of the excluded cases
wire excluded_sop = m0 | m1 | m4 | m5 | m6 | m9 | m10 | m13 | m14;

// Applying De Morgan's law to get POS form
// POS = ~(SOP of excluded cases)
assign out_pos = ~(m0 | m1 | m4 | m5 | m6 | m9 | m10 | m13 | m14);

endmodule