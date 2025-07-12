module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

// out_sop: sum-of-products form
// The numbers 2, 7, and 15 correspond to the minterms:
// 0010, 0111, and 1111 respectively.
// K-map simplification yields:
// out_sop = (a'b & c & d) | (b & c & d) | (a & b & c & d)
//          = (b & c & d) | (a & b & c & d)
//          = b & c & d
assign out_sop = b & c & d;

// out_pos: product-of-sums form
// The numbers 0, 1, 4, 5, 6, 9, 10, 13, and 14 correspond to the maxterms:
// (a+b+c+d)', (a+b+c+d+1)', (a+b'+c+d)', (a+b'+c+d+1)', 
// (a+b+c'+d)', (a+b+c'+d+1)', (a+b'+c+d+1)', (a+b+c+d+1)',
// (a+b'+c'+d+1)', and (a+b+c+d+1)' respectively.
// K-map simplification yields:
// out_pos = (a+b) & (c+d)
assign out_pos = (a | b) & (c | d);

endmodule