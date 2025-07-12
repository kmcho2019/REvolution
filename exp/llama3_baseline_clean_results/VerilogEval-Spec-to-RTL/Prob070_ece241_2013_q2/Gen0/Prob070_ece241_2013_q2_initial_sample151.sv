module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

// Minimum sum-of-products (SOP) form: 
// out_sop = (a'bc'd) + (a'bcd) + (abcd)
assign out_sop = (~a & b & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Minimum product-of-sums (POS) form:
// out_pos = (a + b + c + d)(a + b' + c' + d)(a + b + c + d')(a + b' + c + d')
assign out_pos = (a | b | c | d) & (~a | ~b | ~c | ~d) & (a | ~b | ~c | ~d) & (a | ~b | c | ~d);

endmodule