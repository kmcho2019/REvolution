module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal Sum-of-Products expression:
    // out_sop = a c d + a b d + a' b c' d
    wire term1 = a & c & d;          // covers decimal 15 (1111)
    wire term2 = a & b & d;          // covers decimal 7  (0111)
    wire term3 = (~a) & b & (~c) & d;// covers decimal 2  (0010)
    assign out_sop = term1 | term2 | term3;

    // Minimal Product-of-Sums expression:
    // out_pos = (a + b + d') (a + b' + c + d) (a' + b + c' + d)
    wire sum1 = a | b | (~d);
    wire sum2 = a | (~b) | c | d;
    wire sum3 = (~a) | b | (~c) | d;
    assign out_pos = sum1 & sum2 & sum3;

endmodule