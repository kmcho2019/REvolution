module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal Sum of Products for out_sop:
    // Logic-1 for decimal inputs 2 (0010), 7 (0111), 15 (1111)
    // m2  = ~a & ~b &  c & ~d  => a=0,b=0,c=1,d=0
    // m7  = ~a &  b &  c &  d  => a=0,b=1,c=1,d=1
    // m15 =  a &  b &  c &  d  => a=1,b=1,c=1,d=1
    wire m2  = (~a) & (~b) & c & (~d);
    wire m7  = (~a) & b & c & d;
    wire m15 = a & b & c & d;
    assign out_sop = m2 | m7 | m15;

    // Minimal Product of Sums for out_pos:
    // Logic-0 for decimal inputs:
    // 0(0000),1(0001),4(0100),5(0101),6(0110),9(1001),10(1010),13(1101),14(1110)
    // Don't cares: 3,8,11,12

    // Minimal POS derived:
    // out_pos = (a + b + ~c + d) & (a + ~b + c + d) & (~a + b + c + d)
    wire sum1 = a | b | (~c) | d;
    wire sum2 = a | (~b) | c | d;
    wire sum3 = (~a) | b | c | d;
    assign out_pos = sum1 & sum2 & sum3;

endmodule