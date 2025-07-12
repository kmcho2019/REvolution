module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Divide the input vector into 16 chunks of 16 bits
wire [4:0] count0, count1, count2, count3, count4, count5, count6, count7, count8, count9, count10, count11, count12, count13, count14, count15;

// Calculate the population count for each chunk using a look-up table (LUT)
PopulationCount16 population_count0(in[ 15:  0], count0);
PopulationCount16 population_count1(in[ 31: 16], count1);
PopulationCount16 population_count2(in[ 47: 32], count2);
PopulationCount16 population_count3(in[ 63: 48], count3);
PopulationCount16 population_count4(in[ 79: 64], count4);
PopulationCount16 population_count5(in[ 95: 80], count5);
PopulationCount16 population_count6(in[111: 96], count6);
PopulationCount16 population_count7(in[127:112], count7);
PopulationCount16 population_count8(in[143:128], count8);
PopulationCount16 population_count9(in[159:144], count9);
PopulationCount16 population_count10(in[175:160], count10);
PopulationCount16 population_count11(in[191:176], count11);
PopulationCount16 population_count12(in[207:192], count12);
PopulationCount16 population_count13(in[223:208], count13);
PopulationCount16 population_count14(in[239:224], count14);
PopulationCount16 population_count15(in[254:240], count15);

// Combine the population counts using adders
wire [4:0] sum0, sum1, sum2, sum3, sum4, sum5, sum6, sum7;
assign sum0 = count0 + count1;
assign sum1 = count2 + count3;
assign sum2 = count4 + count5;
assign sum3 = count6 + count7;
assign sum4 = count8 + count9;
assign sum5 = count10 + count11;
assign sum6 = count12 + count13;
assign sum7 = count14 + count15;

wire [4:0] sum8, sum9;
assign sum8 = sum0 + sum1;
assign sum9 = sum2 + sum3;

wire [5:0] sum10, sum11;
assign sum10 = sum4 + sum5;
assign sum11 = sum6 + sum7;

wire [5:0] sum12, sum13;
assign sum12 = sum8 + sum9;
assign sum13 = sum10 + sum11;

// Final addition to produce the 8-bit result
assign out = sum12 + sum13;

endmodule

module PopulationCount16(
    input [15:0] in,
    output [4:0] out
);

// Calculate the population count for the 16-bit input vector
assign out = (in[0]? 1 : 0) + (in[1]? 1 : 0) + (in[2]? 1 : 0) + (in[3]? 1 : 0) +
             (in[4]? 1 : 0) + (in[5]? 1 : 0) + (in[6]? 1 : 0) + (in[7]? 1 : 0) +
             (in[8]? 1 : 0) + (in[9]? 1 : 0) + (in[10]? 1 : 0) + (in[11]? 1 : 0) +
             (in[12]? 1 : 0) + (in[13]? 1 : 0) + (in[14]? 1 : 0) + (in[15]? 1 : 0);

endmodule