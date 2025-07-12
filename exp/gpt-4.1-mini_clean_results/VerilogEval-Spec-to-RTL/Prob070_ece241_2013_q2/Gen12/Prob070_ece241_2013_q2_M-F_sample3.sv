module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal Sum of Products for out_sop:
    // out_sop = m2 + m7 + m15
    // m2  = ~a & ~b &  c & ~d
    // m7  = ~a &  b &  c &  d
    // m15 =  a &  b &  c &  d
    wire m2  = (~a) & (~b) & c & (~d);
    wire m7  = (~a) & b & c & d;
    wire m15 = a & b & c & d;
    assign out_sop = m2 | m7 | m15;

    // Minimal Product of Sums for out_pos:
    // out_pos = (a + b + ~c + d)(a + ~b + c + d)(~a + b + c + d)
    wire sum1 = a | b | (~c) | d;
    wire sum2 = a | (~b) | c | d;
    wire sum3 = (~a) | b | c | d;
    assign out_pos = sum1 & sum2 & sum3;

endmodule