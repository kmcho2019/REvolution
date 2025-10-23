module TopModule(in, out);
    input [254:0] in;
    output [7:0] out;

    wire [7:0] count0;
    wire [7:0] count1;
    wire [7:0] count2;
    wire [7:0] count3;
    wire [7:0] count4;
    wire [7:0] count5;
    wire [7:0] count6;
    wire [7:0] count7;
    wire [7:0] count8;
    wire [7:0] count9;
    wire [7:0] count10;
    wire [7:0] count11;
    wire [7:0] count12;
    wire [7:0] count13;
    wire [7:0] count14;
    wire [7:0] count15;
    wire [7:0] count16;
    wire [7:0] count17;
    wire [7:0] count18;
    wire [7:0] count19;
    wire [7:0] count20;
    wire [7:0] count21;
    wire [7:0] count22;
    wire [7:0] count23;
    wire [7:0] count24;
    wire [7:0] count25;
    wire [7:0] count26;
    wire [7:0] count27;
    wire [7:0] count28;
    wire [7:0] count29;
    wire [7:0] count30;
    wire [7:0] count31;

    // Population count for each 8-bit chunk
    PopulationCount8 pop_count0(in[7:0], count0);
    PopulationCount8 pop_count1(in[15:8], count1);
    PopulationCount8 pop_count2(in[23:16], count2);
    PopulationCount8 pop_count3(in[31:24], count3);
    PopulationCount8 pop_count4(in[39:32], count4);
    PopulationCount8 pop_count5(in[47:40], count5);
    PopulationCount8 pop_count6(in[55:48], count6);
    PopulationCount8 pop_count7(in[63:56], count7);
    PopulationCount8 pop_count8(in[71:64], count8);
    PopulationCount8 pop_count9(in[79:72], count9);
    PopulationCount8 pop_count10(in[87:80], count10);
    PopulationCount8 pop_count11(in[95:88], count11);
    PopulationCount8 pop_count12(in[103:96], count12);
    PopulationCount8 pop_count13(in[111:104], count13);
    PopulationCount8 pop_count14(in[119:112], count14);
    PopulationCount8 pop_count15(in[127:120], count15);
    PopulationCount8 pop_count16(in[135:128], count16);
    PopulationCount8 pop_count17(in[143:136], count17);
    PopulationCount8 pop_count18(in[151:144], count18);
    PopulationCount8 pop_count19(in[159:152], count19);
    PopulationCount8 pop_count20(in[167:160], count20);
    PopulationCount8 pop_count21(in[175:168], count21);
    PopulationCount8 pop_count22(in[183:176], count22);
    PopulationCount8 pop_count23(in[191:184], count23);
    PopulationCount8 pop_count24(in[199:192], count24);
    PopulationCount8 pop_count25(in[207:200], count25);
    PopulationCount8 pop_count26(in[215:208], count26);
    PopulationCount8 pop_count27(in[223:216], count27);
    PopulationCount8 pop_count28(in[231:224], count28);
    PopulationCount8 pop_count29(in[239:232], count29);
    PopulationCount8 pop_count30(in[247:240], count30);
    PopulationCount7 pop_count31(in[254:248], count31);

    // Adder tree to add up the counts from each chunk
    wire [7:0] sum0, sum1, sum2, sum3, sum4, sum5, sum6, sum7, sum8, sum9, sum10, sum11, sum12, sum13, sum14, sum15;
    Adder8 add0(count0, count1, sum0);
    Adder8 add1(count2, count3, sum1);
    Adder8 add2(count4, count5, sum2);
    Adder8 add3(count6, count7, sum3);
    Adder8 add4(count8, count9, sum4);
    Adder8 add5(count10, count11, sum5);
    Adder8 add6(count12, count13, sum6);
    Adder8 add7(count14, count15, sum7);
    Adder8 add8(count16, count17, sum8);
    Adder8 add9(count18, count19, sum9);
    Adder8 add10(count20, count21, sum10);
    Adder8 add11(count22, count23, sum11);
    Adder8 add12(count24, count25, sum12);
    Adder8 add13(count26, count27, sum13);
    Adder8 add14(count28, count29, sum14);
    Adder8 add15(count30, count31, sum15);

    wire [7:0] sum16, sum17, sum18, sum19, sum20, sum21, sum22, sum23, sum24, sum25, sum26, sum27;
    Adder8 add16(sum0, sum1, sum16);
    Adder8 add17(sum2, sum3, sum17);
    Adder8 add18(sum4, sum5, sum18);
    Adder8 add19(sum6, sum7, sum19);
    Adder8 add20(sum8, sum9, sum20);
    Adder8 add21(sum10, sum11, sum21);
    Adder8 add22(sum12, sum13, sum22);
    Adder8 add23(sum14, sum15, sum23);

    wire [7:0] sum28, sum29, sum30;
    Adder8 add28(sum16, sum17, sum28);
    Adder8 add29(sum18, sum19, sum29);
    Adder8 add30(sum20, sum21, sum30);

    wire [7:0] sum31, sum32;
    Adder8 add31(sum22, sum23, sum31);
    Adder8 add32(sum28, sum29, sum32);

    wire [7:0] sum33;
    Adder8 add33(sum30, sum31, sum33);

    wire [7:0] sum34;
    Adder8 add34(sum32, sum33, sum34);

    assign out = sum34;

endmodule

module PopulationCount8(in, out);
    input [7:0] in;
    output [7:0] out;

    assign out = {7'b0, in[0]} + {7'b0, in[1]} + {7'b0, in[2]} + {7'b0, in[3]} + {7'b0, in[4]} + {7'b0, in[5]} + {7'b0, in[6]} + {7'b0, in[7]};
endmodule

module PopulationCount7(in, out);
    input [6:0] in;
    output [7:0] out;

    assign out = {7'b0, in[0]} + {7'b0, in[1]} + {7'b0, in[2]} + {7'b0, in[3]} + {7'b0, in[4]} + {7'b0, in[5]} + {7'b0, in[6]};
endmodule

module Adder8(a, b, out);
    input [7:0] a;
    input [7:0] b;
    output [7:0] out;

    assign out = a + b;
endmodule