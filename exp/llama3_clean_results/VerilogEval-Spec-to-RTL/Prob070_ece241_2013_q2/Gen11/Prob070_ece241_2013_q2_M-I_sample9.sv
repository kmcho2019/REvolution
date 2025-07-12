module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Correct derivation of SOP expression using K-maps
// Considering the binary representations:
// - 2: 0010
// - 7: 0111
// - 15: 1111
assign out_sop = (~a & b & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Correct derivation of POS expression using K-maps
// Considering the negation of binary representations that should produce a logic-0:
// - 0: 0000
// - 1: 0001
// - 4: 0100
// - 5: 0101
// - 6: 0110
// - 9: 1001
// - 10: 1010
// - 13: 1101
// - 14: 1110
assign out_pos = ~(
    (~a & ~b & ~c & ~d) | 
    (~a & ~b & ~c & d) | 
    (~a & ~b & c & ~d) | 
    (~a & ~b & c & d) | 
    (~a & b & ~c & ~d) | 
    (~a & b & ~c & d) | 
    (~a & b & c & ~d) | 
    (a & ~b & ~c & ~d) | 
    (a & ~b & ~c & d) | 
    (a & ~b & c & ~d) | 
    (a & ~b & c & d) | 
    (a & b & ~c & ~d) | 
    (a & b & ~c & d) 
);

endmodule