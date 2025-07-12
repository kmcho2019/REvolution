// Simplified Comparator module
module Comparator(
    input  a,
    input  b,
    output out
);
    assign out = (a == b)? 1'b1 : 1'b0;
endmodule

// TopModule with manual loop unrolling for optimization
module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    // Manual instantiation of comparator modules for optimization
    Comparator cmp00(a, a, out[0]);
    Comparator cmp01(a, b, out[1]);
    Comparator cmp02(a, c, out[2]);
    Comparator cmp03(a, d, out[3]);
    Comparator cmp04(a, e, out[4]);
    Comparator cmp10(b, a, out[5]);
    Comparator cmp11(b, b, out[6]);
    Comparator cmp12(b, c, out[7]);
    Comparator cmp13(b, d, out[8]);
    Comparator cmp14(b, e, out[9]);
    Comparator cmp20(c, a, out[10]);
    Comparator cmp21(c, b, out[11]);
    Comparator cmp22(c, c, out[12]);
    Comparator cmp23(c, d, out[13]);
    Comparator cmp24(c, e, out[14]);
    Comparator cmp30(d, a, out[15]);
    Comparator cmp31(d, b, out[16]);
    Comparator cmp32(d, c, out[17]);
    Comparator cmp33(d, d, out[18]);
    Comparator cmp34(d, e, out[19]);
    Comparator cmp40(e, a, out[20]);
    Comparator cmp41(e, b, out[21]);
    Comparator cmp42(e, c, out[22]);
    Comparator cmp43(e, d, out[23]);
    Comparator cmp44(e, e, out[24]);

endmodule