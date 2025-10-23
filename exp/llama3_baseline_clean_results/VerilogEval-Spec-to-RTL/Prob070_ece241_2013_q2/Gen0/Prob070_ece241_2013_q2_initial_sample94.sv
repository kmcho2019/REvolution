module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimum sum-of-products form for out_sop
    assign out_sop = (b & ~a & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

    // Minimum product-of-sums form for out_pos
    assign out_pos = (~(a | b | c | d)) & (~(~a & ~b & ~c & ~d)) & (~(a & ~b & ~c & ~d)) & 
                     (~(a & b & ~c & ~d)) & (~(a & b & ~c & d)) & (~(a & b & c & ~d)) & 
                     (~(~a & b & ~c & ~d)) & (~(~a & b & ~c & d)) & 
                     (~(~a & b & c & d)) & (~(~a & ~b & c & ~d));

    // However, it can be simplified by considering all cases where out_pos should be 0
    // Then, use De Morgan's laws and other Boolean algebra laws to simplify the expression
    // After simplification, we can write the out_pos in the following way
    assign out_pos = ((~a | ~b) & (~c | ~d)) & ((a | b) | (c | d));

endmodule