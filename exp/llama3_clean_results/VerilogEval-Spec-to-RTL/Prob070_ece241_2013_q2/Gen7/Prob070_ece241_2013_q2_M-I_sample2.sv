module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

// Minimum sum-of-products form for out_sop
// Using a K-map or similar method to find the minimum sum-of-products form
assign out_sop = (~a & b & ~c & ~d) || (~a & b & c & d) || (a & b & c & d);

// Minimum product-of-sums form for out_pos
// Directly implementing the minimum product-of-sums form
assign out_pos = (~a & b & c & d) || (a & b & c & d) || (~a & b & ~c & ~d);

endmodule