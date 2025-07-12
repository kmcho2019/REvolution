module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

// Minimum sum-of-products form
assign out_sop = (~a & b & c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Minimum product-of-sums form
// Use a K-map or a logic synthesis tool for precise simplification
assign out_pos = ~( (a | ~b) & (a | ~c) & (~b | ~d) & (b | c) & (b | d) );

endmodule