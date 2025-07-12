module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Inputs represent a 4-bit number: a=MSB, d=LSB

// SOP: output=1 for inputs 2,7,15
// 2: a'b' c d'
// 7,15: b c d (a don't care)
assign out_sop = (b & c & d) | (~a & ~b & c & ~d);

// POS: output=0 for inputs 0,1,4,5,6,9,10,13,14
// Minimal POS by K-map grouping:
assign out_pos = 
    (a | b | c | d) &
    (a | ~b | d) &
    (~a | b | c) &
    (~a | ~b | c | ~d);

endmodule