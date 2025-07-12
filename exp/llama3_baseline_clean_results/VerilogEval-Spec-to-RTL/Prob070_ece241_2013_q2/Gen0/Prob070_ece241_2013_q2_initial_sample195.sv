module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimum sum-of-products (SOP) form for out_sop
assign out_sop = (~a & b & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Minimum product-of-sums (POS) form for out_pos
// To find the POS form, first consider the SOP form, then apply De Morgan's laws
// The SOP form for out_sop is: (~a & b & ~c & ~d) | (~a & b & c & d) | (a & b & c & d)
// The POS form for out_pos is the complement of the SOP form for the complement of out_pos
// We'll apply De Morgan's laws and simplification to find the POS form
assign out_pos = (a | ~b | c | d) & (a | ~b | ~c | d) & (~a | ~b | ~c | ~d);

endmodule