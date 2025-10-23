module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal Sum of Products (SOP)
    wire m2  = ~a & ~b &  c & ~d; // decimal 2
    wire m7  = ~a &  b &  c &  d; // decimal 7
    wire m15 =  a &  b &  c &  d; // decimal 15

    assign out_sop = m2 | m7 | m15;

    // Minimal Product of Sums (POS)
    // (a + b + c + d') (a + b' + c' + d) (a' + b + c + d)
    wire sum1 = a | b | c | ~d;
    wire sum2 = a | ~b | ~c | d;
    wire sum3 = ~a | b | c | d;

    assign out_pos = sum1 & sum2 & sum3;

endmodule