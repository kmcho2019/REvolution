module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Minimum sum-of-products (SOP) form:
    // The minterms for the input conditions 2, 7, and 15 are:
    // 0010: ~a*b*~c*d
    // 0111: ~a*b*c*d
    // 1111: a*b*c*d
    // So, the minimum SOP form is:
    assign out_sop = (~a & b & ~c & d) | (~a & b & c & d) | (a & b & c & d);

    // Minimum product-of-sums (POS) form:
    // The maxterms for the input conditions 0, 1, 4, 5, 6, 9, 10, 13, and 14 are:
    // 0000: (a+b+c+d)
    // 0001: (a+b+c+~d)
    // 0100: (a+~b+c+d)
    // 0101: (a+~b+c+~d)
    // 0110: (a+~b+~c+d)
    // 1001: (~a+b+c+d)
    // 1010: (~a+b+c+~d)
    // 1101: (~a+~b+c+d)
    // 1110: (~a+~b+~c+d)
    // So, the minimum POS form is:
    assign out_pos = (a | b | c | d) & (a | b | c | ~d) & (a | ~b | c | d) & (a | ~b | c | ~d) & (a | ~b | ~c | d) & (~a | b | c | d) & (~a | b | c | ~d) & (~a | ~b | c | d) & (~a | ~b | ~c | d);

endmodule