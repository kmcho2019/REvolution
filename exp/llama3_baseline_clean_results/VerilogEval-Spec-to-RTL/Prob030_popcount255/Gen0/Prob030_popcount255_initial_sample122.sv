module TopModule(
    input  [254:0] in,
    output [7:0] out
);

    wire [3:0] count0, count1, count2, count3, count4, count5, count6, count7, 
             count8, count9, count10, count11, count12, count13, count14, count15, count16;

    // Count '1's in each 15-bit group
    Counter15 counter0(in[14:0], count0);
    Counter15 counter1(in[29:15], count1);
    Counter15 counter2(in[44:30], count2);
    Counter15 counter3(in[59:45], count3);
    Counter15 counter4(in[74:60], count4);
    Counter15 counter5(in[89:75], count5);
    Counter15 counter6(in[104:90], count6);
    Counter15 counter7(in[119:105], count7);
    Counter15 counter8(in[134:120], count8);
    Counter15 counter9(in[149:135], count9);
    Counter15 counter10(in[164:150], count10);
    Counter15 counter11(in[179:165], count11);
    Counter15 counter12(in[194:180], count12);
    Counter15 counter13(in[209:195], count13);
    Counter15 counter14(in[224:210], count14);
    Counter15 counter15(in[239:225], count15);
    Counter15 counter16(in[254:240], count16);

    // Add counts from each group
    wire [7:0] sum0, sum1, sum2, sum3, sum4, sum5, sum6, sum7;
    Add4 add0(count0, count1, count2, count3, sum0);
    Add4 add1(count4, count5, count6, count7, sum1);
    Add4 add2(count8, count9, count10, count11, sum2);
    Add4 add3(count12, count13, count14, count15, sum3);
    Add4 add4(count16, 4'b0, 4'b0, 4'b0, sum4);
    Add4 add5(sum0, sum1, sum2, sum3, sum5);
    Add4 add6(sum4, 4'b0, 4'b0, 4'b0, sum6);
    Add4 add7(sum5, sum6, 4'b0, 4'b0, sum7);

    // Output the final sum
    assign out = sum7[7:0];

endmodule

// Counter module for 15-bit input
module Counter15(
    input  [14:0] in,
    output [3:0] out
);

    assign out = in[0] + in[1] + in[2] + in[3] + in[4] + in[5] + in[6] + in[7] + 
                 in[8] + in[9] + in[10] + in[11] + in[12] + in[13] + in[14];

endmodule

// Adder module for 4-bit numbers
module Add4(
    input  [3:0] a, b, c, d,
    output [7:0] out
);

    assign out = a + b + c + d;

endmodule