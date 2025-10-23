module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

// Minimum Sum-of-Products form for out_sop
assign out_sop = (~a & b & ~c & d) | (~a & b & c & d) | (a & b & c & d);

// Minimum Product-of-Sums form for out_pos
// This involves more complex logic to ensure only the specified conditions are met
// and requires careful consideration of the sums that cover the output 1 conditions
assign out_pos = (a | b | c | d) & (~a | b | c | d) & (~a | b | ~c | d);

endmodule