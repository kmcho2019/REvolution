module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

// out_sop is in minimum sum-of-products form
// The valid input conditions are 2 (0010), 7 (0111), and 15 (1111)
assign out_sop = (b & ~a) | (a & b & c & d);

// out_pos is in minimum product-of-sums form
// The simplified expression covers all the invalid input conditions
assign out_pos = (~a | b) & (~d | b | c) & (a | ~c | ~d);

endmodule