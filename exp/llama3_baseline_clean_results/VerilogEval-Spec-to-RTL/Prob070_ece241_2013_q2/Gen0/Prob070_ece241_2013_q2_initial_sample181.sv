module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

// Minimum Sum-of-Products (SOP) form for out_sop
assign out_sop = (~a & ~b & c & d) | (~a & b & c & d) | (a & b & c & d);

// Minimum Product-of-Sums (POS) form for out_pos
// The conditions given result in the following maxterms for out_pos to be '0'
// Since out_pos is the product of these maxterms, we express it as follows
assign out_pos = (a | b | c | d) & (a | b | c | ~d) & (a | ~b | c | d) & (a | ~b | c | ~d) & 
                 (a | ~b | ~c | d) & (~a | b | c | ~d) & (~a | b | ~c | d) & (~a | ~b | c | ~d) & (~a | ~b | ~c | d);

endmodule