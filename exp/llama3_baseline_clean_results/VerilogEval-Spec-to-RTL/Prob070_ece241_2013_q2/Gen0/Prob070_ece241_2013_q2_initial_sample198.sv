module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimum Sum-of-Products (SOP) form
assign out_sop = (~a & b & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Minimum Product-of-Sums (POS) form
// The condition for out_pos to be 1 is when none of the maxterms for logic-0 output are true
// Maxterms for logic-0 output are: 
// (a | ~b | c | d), (~a | b | c | d), (~a | ~b | c | d), (~a | ~b | ~c | d), (~a | ~b | ~c | ~d), 
// (a | ~b | ~c | d), (a | ~b | c | ~d), (a | b | ~c | d), (a | b | ~c | ~d), 
// However, a more minimal representation for the POS can be derived as follows:
// The condition is true when none of the maxterms for 0, 1, 4, 5, 6, 9, 10, 13, 14 are true
// We observe that 0, 1, 4, 5, 6, 9, 10, 13, 14 can be covered by simpler maxterms
// This can be expressed as: 
// (a | ~b) & (b | ~c) & (c | ~d) & (~a | d)
assign out_pos = (a | ~b) & (b | ~c) & (c | ~d) & (~a | d);

endmodule