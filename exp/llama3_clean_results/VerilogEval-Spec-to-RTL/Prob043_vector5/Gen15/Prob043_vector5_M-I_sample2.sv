// Define a small, reusable comparator module
module Comparator(
    input  a,
    input  b,
    output out
);
    assign out = ~(a ^ b);
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

    // Define input array
    wire [4:0] inputs = {a, b, c, d, e};

    // Instantiate comparator modules manually
    Comparator cmp0(inputs[0], inputs[0], out[0]);
    Comparator cmp1(inputs[0], inputs[1], out[1]);
    Comparator cmp2(inputs[0], inputs[2], out[2]);
    Comparator cmp3(inputs[0], inputs[3], out[3]);
    Comparator cmp4(inputs[0], inputs[4], out[4]);
    Comparator cmp5(inputs[1], inputs[0], out[5]);
    Comparator cmp6(inputs[1], inputs[1], out[6]);
    Comparator cmp7(inputs[1], inputs[2], out[7]);
    Comparator cmp8(inputs[1], inputs[3], out[8]);
    Comparator cmp9(inputs[1], inputs[4], out[9]);
    Comparator cmp10(inputs[2], inputs[0], out[10]);
    Comparator cmp11(inputs[2], inputs[1], out[11]);
    Comparator cmp12(inputs[2], inputs[2], out[12]);
    Comparator cmp13(inputs[2], inputs[3], out[13]);
    Comparator cmp14(inputs[2], inputs[4], out[14]);
    Comparator cmp15(inputs[3], inputs[0], out[15]);
    Comparator cmp16(inputs[3], inputs[1], out[16]);
    Comparator cmp17(inputs[3], inputs[2], out[17]);
    Comparator cmp18(inputs[3], inputs[3], out[18]);
    Comparator cmp19(inputs[3], inputs[4], out[19]);
    Comparator cmp20(inputs[4], inputs[0], out[20]);
    Comparator cmp21(inputs[4], inputs[1], out[21]);
    Comparator cmp22(inputs[4], inputs[2], out[22]);
    Comparator cmp23(inputs[4], inputs[3], out[23]);
    assign out[24] = 1'b1;

endmodule