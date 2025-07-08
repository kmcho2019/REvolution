module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal sum-of-products form
    assign out_sop = (c & d) | (~a & ~b & c & ~d);

    // Minimal product-of-sums form
    assign out_pos = (a | b | c | d) 
                   & (a | ~b | c | ~d) 
                   & (~a | b | c | ~d);

endmodule