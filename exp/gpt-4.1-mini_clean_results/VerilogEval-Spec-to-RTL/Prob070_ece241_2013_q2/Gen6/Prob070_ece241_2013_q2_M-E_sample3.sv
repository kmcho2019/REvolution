module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimal SOP for out_sop (outputs 1 for decimal 2,7,15):
// Decimal 2 = 0 0 1 0 -> a'b'c d'
// Decimal 7 = 0 1 1 1 -> a b c d
// Decimal 15=1 1 1 1 -> a b c d
// Minimal SOP grouping yields:
// out_sop = a b c d + a'b c d' + a b' c d  (Note: check minimization carefully)
// Actually, minterms for 2,7,15 are: 2(0010),7(0111),15(1111)
// Minterms: m2= a'b' c d', m7=a' b c d, m15=a b c d
// Attempt to find minimal SOP from these three:
// From 7 and 15: b c d (since a is 0 or 1) => b c d
// From 2: a'b' c d'
// So minimal SOP: out_sop = (b & c & d) | (~a & ~b & c & ~d)

assign out_sop = (b & c & d) | (~a & ~b & c & ~d);

// Minimal POS for out_pos (output 1 when outputs zero on 0,1,4,5,6,9,10,13,14):
// Those zeroes correspond to maxterms:
// 0 (0000): a + b + c + d
// 1 (0001): a + b + c + ~d
// 4 (0100): a + ~b + c + d
// 5 (0101): a + ~b + c + ~d
// 6 (0110): a + ~b + ~c + d
// 9 (1001): ~a + b + c + ~d
// 10(1010): ~a + b + ~c + d
// 13(1101): ~a + ~b + c + ~d
// 14(1110): ~a + ~b + ~c + d
// Minimal POS from K-map grouping:
// out_pos = (a + b + c + d)(a + ~b + c + d)(~a + b + c + d)

// Assign out_pos as product of sums from these maxterms:
assign out_pos = (a | b | c | d) & 
                 (a | ~b | c | d) & 
                 (~a | b | c | d);

endmodule