module TopModule(in, out);
    input [254:0] in;
    output [7:0] out;

    wire [3:0] cnt0, cnt1, cnt2, cnt3, cnt4, cnt5, cnt6, cnt7, cnt8, cnt9, cnt10, cnt11, cnt12, cnt13, cnt14, cnt15;
    wire [3:0] sum0, sum1, sum2, sum3, sum4, sum5, sum6, sum7;

    // 16-bit population counters for the first 15 chunks
    PopCount16 popcnt0(in[15:0], cnt0);
    PopCount16 popcnt1(in[31:16], cnt1);
    PopCount16 popcnt2(in[47:32], cnt2);
    PopCount16 popcnt3(in[63:48], cnt3);
    PopCount16 popcnt4(in[79:64], cnt4);
    PopCount16 popcnt5(in[95:80], cnt5);
    PopCount16 popcnt6(in[111:96], cnt6);
    PopCount16 popcnt7(in[127:112], cnt7);
    PopCount16 popcnt8(in[143:128], cnt8);
    PopCount16 popcnt9(in[159:144], cnt9);
    PopCount16 popcnt10(in[175:160], cnt10);
    PopCount16 popcnt11(in[191:176], cnt11);
    PopCount16 popcnt12(in[207:192], cnt12);
    PopCount16 popcnt13(in[223:208], cnt13);
    PopCount16 popcnt14(in[239:224], cnt14);
    PopCount16 popcnt15(in[255:240], cnt15);

    // 7-bit population counter for the last chunk
    PopCount7 popcnt16(in[254:248], cnt16);

    // First level of summation: sum counts from pairs of chunks
    Add4 sum0(cnt0, cnt1, sum0);
    Add4 sum1(cnt2, cnt3, sum1);
    Add4 sum2(cnt4, cnt5, sum2);
    Add4 sum3(cnt6, cnt7, sum3);
    Add4 sum4(cnt8, cnt9, sum4);
    Add4 sum5(cnt10, cnt11, sum5);
    Add4 sum6(cnt12, cnt13, sum6);
    Add4 sum7(cnt14, cnt15, sum7);

    // Second level of summation: sum counts from pairs of sums
    wire [7:0] sum8, sum9, sum10, sum11;
    Add8 sum8_9(sum0, sum1, sum8);
    Add8 sum10_11(sum2, sum3, sum9);
    Add8 sum12_13(sum4, sum5, sum10);
    Add8 sum14_15(sum6, sum7, sum11);

    // Final summation: sum counts from pairs of sums and the last chunk's count
    wire [7:0] sum12, sum13;
    Add8 sum16(sum8, sum9, sum12);
    Add8 sum17(sum10, sum11, sum13);

    // Final addition
    Add8Final sum18(sum12, sum13, {4'b0, cnt16}, out);

endmodule

// 16-bit population counter
module PopCount16(in, out);
    input [15:0] in;
    output [3:0] out;

    assign out = in[0] + in[1] + in[2] + in[3] + in[4] + in[5] + in[6] + in[7] +
                 in[8] + in[9] + in[10] + in[11] + in[12] + in[13] + in[14] + in[15];
endmodule

// 7-bit population counter
module PopCount7(in, out);
    input [6:0] in;
    output [3:0] out;

    assign out = in[0] + in[1] + in[2] + in[3] + in[4] + in[5] + in[6];
endmodule

// 4-bit adder
module Add4(a, b, out);
    input [3:0] a;
    input [3:0] b;
    output [3:0] out;

    assign out = a + b;
endmodule

// 8-bit adder
module Add8(a, b, out);
    input [3:0] a;
    input [3:0] b;
    output [7:0] out;

    assign out = {4'b0, a} + {4'b0, b};
endmodule

// Final 8-bit adder
module Add8Final(a, b, c, out);
    input [7:0] a;
    input [7:0] b;
    input [7:0] c;
    output [7:0] out;

    assign out = a + b + c;
endmodule