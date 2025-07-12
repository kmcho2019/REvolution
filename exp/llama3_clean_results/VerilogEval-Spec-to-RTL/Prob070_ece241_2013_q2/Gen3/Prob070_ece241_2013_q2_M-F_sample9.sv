module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

// out_sop is in minimum sum-of-products form
// Directly considering the valid conditions for out_sop to be logic-1
assign out_sop = (~a & b & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

// out_pos is in minimum product-of-sums form
// Considering the conditions for out_pos to be logic-1
assign out_pos = (a | b | c | d) & (a | ~b | c | d) & (~a | ~b | c | d) & (a | b | ~c | d) & (a | b | c | ~d);

endmodule