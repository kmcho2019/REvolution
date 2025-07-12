module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Inputs: a,b,c,d with 'a' as MSB, 'd' as LSB.

    // Desired output:
    // out=1 for decimal inputs 2(0010),7(0111),15(1111)
    // out=0 for decimal inputs 0,1,4,5,6,9,10,13,14
    // inputs 3,8,11,12 are don't-cares

    // Minimal Sum of Products (SOP) form for out:
    // out = (b & c & d) + (~a & ~b & c & ~d)
    // This covers:
    // 7 (0111): b=1,c=1,d=1
    // 15(1111): b=1,c=1,d=1 (also covers 15)
    // 2 (0010): ~a & ~b & c & ~d

    wire term1 = b & c & d;
    wire term2 = (~a) & (~b) & c & (~d);
    assign out_sop = term1 | term2;

    // Minimal Product of Sums (POS) form for out:
    // out = (b' + c' + d') & (a + b + c' + d)
    // This matches the complement form of the function and satisfies the problem's output mapping.

    wire sum1 = (~b) | (~c) | (~d);
    wire sum2 = a | b | (~c) | d;
    assign out_pos = sum1 & sum2;

endmodule