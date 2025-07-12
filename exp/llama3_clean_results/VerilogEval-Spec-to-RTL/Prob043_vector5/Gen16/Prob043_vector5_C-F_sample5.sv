// Define a small, reusable comparator module
module Comparator(
    input  a,
    input  b,
    output out
);
    assign out = (a == b);
endmodule

// TopModule utilizing the Comparator module
module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    // Instantiate the comparator module for each comparison
    Comparator cmp0(a, a, out[24]);
    Comparator cmp1(a, b, out[23]);
    Comparator cmp2(a, c, out[22]);
    Comparator cmp3(a, d, out[21]);
    Comparator cmp4(a, e, out[20]);

    Comparator cmp5(b, a, out[19]);
    Comparator cmp6(b, b, out[18]);
    Comparator cmp7(b, c, out[17]);
    Comparator cmp8(b, d, out[16]);
    Comparator cmp9(b, e, out[15]);

    Comparator cmp10(c, a, out[14]);
    Comparator cmp11(c, b, out[13]);
    Comparator cmp12(c, c, out[12]);
    Comparator cmp13(c, d, out[11]);
    Comparator cmp14(c, e, out[10]);

    Comparator cmp15(d, a, out[9]);
    Comparator cmp16(d, b, out[8]);
    Comparator cmp17(d, c, out[7]);
    Comparator cmp18(d, d, out[6]);
    Comparator cmp19(d, e, out[5]);

    Comparator cmp20(e, a, out[4]);
    Comparator cmp21(e, b, out[3]);
    Comparator cmp22(e, c, out[2]);
    Comparator cmp23(e, d, out[1]);
    Comparator cmp24(e, e, out[0]);

endmodule