module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal Sum-of-Products (SOP) implementation
    // out_sop = (b & c & d) | (a' & b' & c & d')
    wire term1 = b & c & d;
    wire term2 = (~a) & (~b) & c & (~d);
    assign out_sop = term1 | term2;

    // Minimal Product-of-Sums (POS) implementation
    // out_pos = (a + b + c + d) & (a + b + c + ~d) & (a + b' + c + d) &
    //           (a + b' + c' + d) & (a' + b + c + d)
    wire sum1 = a | b | c | d;
    wire sum2 = a | b | c | (~d);
    wire sum3 = a | (~b) | c | d;
    wire sum4 = a | (~b) | (~c) | d;
    wire sum5 = (~a) | b | c | d;
    assign out_pos = sum1 & sum2 & sum3 & sum4 & sum5;

endmodule