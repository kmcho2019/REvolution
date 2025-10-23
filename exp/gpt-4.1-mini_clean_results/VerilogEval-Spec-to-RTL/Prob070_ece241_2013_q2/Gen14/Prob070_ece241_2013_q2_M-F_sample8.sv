module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // out_sop minimal sum-of-products form:
    // out_sop = b AND ( (NOT a AND NOT c AND NOT d) OR (c AND d) )
    wire term1 = (~a) & (~c) & (~d);
    wire term2 = c & d;
    assign out_sop = b & (term1 | term2);

    // out_pos minimal product-of-sums form:
    // out_pos = (a + c + d) AND (NOT b + NOT c + d)
    wire sum1 = a | c | d;
    wire sum2 = (~b) | (~c) | d;
    assign out_pos = sum1 & sum2;

endmodule