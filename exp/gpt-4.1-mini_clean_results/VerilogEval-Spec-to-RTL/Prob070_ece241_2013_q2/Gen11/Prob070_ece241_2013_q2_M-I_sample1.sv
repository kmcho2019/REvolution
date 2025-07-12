module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal Sum of Products for out_sop:
    // out_sop = a c d + a b c + ~a ~b c ~d
    wire term1 = a & c & d;
    wire term2 = a & b & c;
    wire term3 = (~a) & (~b) & c & (~d);
    assign out_sop = term1 | term2 | term3;

    // Minimal Product of Sums for out_pos:
    // out_pos = (a + b + ~c + d) (a + ~b + c + d) (~a + b + c + d)
    wire sum1 = a | b | (~c) | d;
    wire sum2 = a | (~b) | c | d;
    wire sum3 = (~a) | b | c | d;
    assign out_pos = sum1 & sum2 & sum3;

endmodule