module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

// Minimum Sum-of-Products (SOP) form for out_sop
assign out_sop = (~a & ~b & c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Minimum Product-of-Sums (POS) form for out_pos
// First, find the maximum sum (OR) of the complements of the terms
// Then, take the complement of that result (De Morgan's law)
assign out_pos = ~( (a | b | c | d) & (a | b | c | ~d) & (a | ~b | ~c | d) & (a | ~b | ~c | ~d) & (~a | b | ~c | d) & (~a | b | ~c | ~d) & (~a | b | c | ~d) & (~a | ~b | ~c | d) & (~a | ~b | ~c | ~d) & (~a | ~b | c | d) & (~a | ~b | c | ~d) );

endmodule