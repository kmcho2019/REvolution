module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimal SOP for out_sop = sum of minterms for decimal 2,7,15:
// 2  = 0 0 1 0 => ~a & ~b & c & ~d
// 7  = 0 1 1 1 => ~a &  b & c &  d
// 15 = 1 1 1 1 =>  a &  b & c &  d
// Grouping minterms 7 and 15 (only 'a' differs) => b & c & d
// Final minimal SOP:
// out_sop = (b & c & d) | (~a & ~b & c & ~d);

assign out_sop = (b & c & d) | (~a & ~b & c & ~d);

// Minimal POS for out_pos = product of maxterms for zeros:
// zeros at decimal values: 0,1,4,5,6,9,10,13,14
// Corresponding maxterms:
// 0 (0000):  (a + b + c + d)
// 1 (0001):  (a + b + c + ~d)
// 4 (0100):  (a + ~b + c + d)
// 5 (0101):  (a + ~b + c + ~d)
// 6 (0110):  (a + ~b + ~c + d)
// 9 (1001):  (~a + b + c + ~d)
// 10(1010):  (~a + b + ~c + d)
// 13(1101):  (~a + ~b + c + ~d)
// 14(1110):  (~a + ~b + ~c + d)

// Group maxterms to minimize:
// Group 1: (a + b + c + d) covers 0
// Group 2: (a + ~b + c + d) covers 4,6
// Group 3: (~a + b + c + d) covers 10
// Group 4: (a + b + c + ~d) covers 1
// Group 5: (a + ~b + c + ~d) covers 5
// Group 6: (~a + b + c + ~d) covers 9,13

// Minimal POS expression covering all zeros with these groups:
assign out_pos = (a | b | c | d) &
                 (a | ~b | c | d) &
                 (~a | b | c | d) &
                 (a | b | c | ~d) &
                 (a | ~b | c | ~d) &
                 (~a | b | c | ~d);

endmodule