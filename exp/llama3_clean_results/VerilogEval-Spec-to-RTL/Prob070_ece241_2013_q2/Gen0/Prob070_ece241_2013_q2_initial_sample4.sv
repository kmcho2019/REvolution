module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

// Minimum sum-of-products form: out_sop = (a*b*c*d') + (a*b*c*d) + (a*b*c*d')
// Since d and d' cover all possible values of d, we can simplify to:
// out_sop = (a*b*c)

// Minimum product-of-sums form: 
// Maxterms for out_pos = 0 are: (a*b*c*d), (a*b*c*d'), (a*b*c'*d), (a*b*c'*d'), 
// (a*b'*c*d), (a*b'*c*d'), (a*b'*c'*d), (a*b'*c'*d'), (a'*b*c*d), (a'*b*c*d')
// Taking complements and simplifying: out_pos = (a + b + c) * (a + b + d) * (a + c + d) * (b + c + d)

assign out_sop = a & b & c;
assign out_pos = (a | b | c) & (a | b | d) & (a | c | d) & (b | c | d);

endmodule