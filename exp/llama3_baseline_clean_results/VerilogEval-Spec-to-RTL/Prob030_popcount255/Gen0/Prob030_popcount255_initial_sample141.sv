module TopModule(
    input [254:0] in,
    output [7:0] out
);

    // Count the number of '1's in each 8-bit chunk
    wire [4:0] count0;
    wire [4:0] count1;
    wire [4:0] count2;
    wire [4:0] count3;
    wire [4:0] count4;
    wire [4:0] count5;
    wire [4:0] count6;
    wire [4:0] count7;
    wire [4:0] count8;
    wire [4:0] count9;
    wire [4:0] count10;
    wire [4:0] count11;
    wire [4:0] count12;
    wire [4:0] count13;
    wire [4:0] count14;
    wire [4:0] count15;
    wire [4:0] count16;
    wire [4:0] count17;
    wire [4:0] count18;
    wire [4:0] count19;
    wire [4:0] count20;
    wire [4:0] count21;
    wire [4:0] count22;
    wire [4:0] count23;
    wire [4:0] count24;
    wire [4:0] count25;
    wire [4:0] count26;
    wire [4:0] count27;
    wire [4:0] count28;
    wire [4:0] count29;
    wire [4:0] count30;
    wire [2:0] count31;

    population_count_8bit pc0(in[7:0], count0);
    population_count_8bit pc1(in[15:8], count1);
    population_count_8bit pc2(in[23:16], count2);
    population_count_8bit pc3(in[31:24], count3);
    population_count_8bit pc4(in[39:32], count4);
    population_count_8bit pc5(in[47:40], count5);
    population_count_8bit pc6(in[55:48], count6);
    population_count_8bit pc7(in[63:56], count7);
    population_count_8bit pc8(in[71:64], count8);
    population_count_8bit pc9(in[79:72], count9);
    population_count_8bit pc10(in[87:80], count10);
    population_count_8bit pc11(in[95:88], count11);
    population_count_8bit pc12(in[103:96], count12);
    population_count_8bit pc13(in[111:104], count13);
    population_count_8bit pc14(in[119:112], count14);
    population_count_8bit pc15(in[127:120], count15);
    population_count_8bit pc16(in[135:128], count16);
    population_count_8bit pc17(in[143:136], count17);
    population_count_8bit pc18(in[151:144], count18);
    population_count_8bit pc19(in[159:152], count19);
    population_count_8bit pc20(in[167:160], count20);
    population_count_8bit pc21(in[175:168], count21);
    population_count_8bit pc22(in[183:176], count22);
    population_count_8bit pc23(in[191:184], count23);
    population_count_8bit pc24(in[199:192], count24);
    population_count_8bit pc25(in[207:200], count25);
    population_count_8bit pc26(in[215:208], count26);
    population_count_8bit pc27(in[223:216], count27);
    population_count_8bit pc28(in[231:224], count28);
    population_count_8bit pc29(in[239:232], count29);
    population_count_8bit pc30(in[247:240], count30);
    population_count_7bit pc31(in[254:248], count31);

    // Sum up the counts
    wire [4:0] sum0;
    assign sum0 = count0 + count1;

    wire [4:0] sum1;
    assign sum1 = count2 + count3;

    wire [4:0] sum2;
    assign sum2 = count4 + count5;

    wire [4:0] sum3;
    assign sum3 = count6 + count7;

    wire [4:0] sum4;
    assign sum4 = count8 + count9;

    wire [4:0] sum5;
    assign sum5 = count10 + count11;

    wire [4:0] sum6;
    assign sum6 = count12 + count13;

    wire [4:0] sum7;
    assign sum7 = count14 + count15;

    wire [4:0] sum8;
    assign sum8 = count16 + count17;

    wire [4:0] sum9;
    assign sum9 = count18 + count19;

    wire [4:0] sum10;
    assign sum10 = count20 + count21;

    wire [4:0] sum11;
    assign sum11 = count22 + count23;

    wire [4:0] sum12;
    assign sum12 = count24 + count25;

    wire [4:0] sum13;
    assign sum13 = count26 + count27;

    wire [4:0] sum14;
    assign sum14 = count28 + count29;

    wire [4:0] sum15;
    assign sum15 = count30 + count31;

    // Further sum up the counts
    wire [5:0] sum16;
    assign sum16 = sum0 + sum1;

    wire [5:0] sum17;
    assign sum17 = sum2 + sum3;

    wire [5:0] sum18;
    assign sum18 = sum4 + sum5;

    wire [5:0] sum19;
    assign sum19 = sum6 + sum7;

    wire [5:0] sum20;
    assign sum20 = sum8 + sum9;

    wire [5:0] sum21;
    assign sum21 = sum10 + sum11;

    wire [5:0] sum22;
    assign sum22 = sum12 + sum13;

    wire [5:0] sum23;
    assign sum23 = sum14 + sum15;

    // Further sum up the counts
    wire [6:0] sum24;
    assign sum24 = sum16 + sum17;

    wire [6:0] sum25;
    assign sum25 = sum18 + sum19;

    wire [6:0] sum26;
    assign sum26 = sum20 + sum21;

    wire [6:0] sum27;
    assign sum27 = sum22 + sum23;

    // Further sum up the counts
    wire [7:0] sum28;
    assign sum28 = sum24 + sum25;

    wire [7:0] sum29;
    assign sum29 = sum26 + sum27;

    // Final sum
    assign out = sum28 + sum29;

endmodule

module population_count_8bit(
    input [7:0] in,
    output [4:0] out
);
    assign out = {1'b0, in[0]} + {1'b0, in[1]} + {1'b0, in[2]} + {1'b0, in[3]} + 
                 {1'b0, in[4]} + {1'b0, in[5]} + {1'b0, in[6]} + {1'b0, in[7]};
endmodule

module population_count_7bit(
    input [6:0] in,
    output [2:0] out
);
    assign out = {1'b0, in[0]} + {1'b0, in[1]} + {1'b0, in[2]} + {1'b0, in[3]} + 
                 {1'b0, in[4]} + {1'b0, in[5]} + {1'b0, in[6]};
endmodule