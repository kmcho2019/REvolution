module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimum sum-of-products expression:
    // out_sop = a'b'cd' + bcd
    assign out_sop = (~a & ~b & c & ~d) | (b & c & d);

    // Minimum product-of-sums expression:
    // out_pos = (a + b + c + d)(a + b' + c + d')(a' + b + c + d')(a' + b' + c' + d)
    assign out_pos = (a | b | c | d) 
                   & (a | ~b | c | ~d)
                   & (~a | b | c | ~d)
                   & (~a | ~b | ~c | d);

endmodule