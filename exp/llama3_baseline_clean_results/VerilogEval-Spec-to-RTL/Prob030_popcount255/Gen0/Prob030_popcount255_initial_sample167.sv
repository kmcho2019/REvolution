module TopModule(
    input [254:0] in,
    output [7:0] out
);

    wire [15:0] count0, count1, count2, count3, count4, count5, count6, count7, count8, count9, count10, count11, count12, count13, count14, count15;
    
    // Count the number of '1's in each group of 16 bits
    PopulationCount16 population_count0(in[15:0], count0);
    PopulationCount16 population_count1(in[31:16], count1);
    PopulationCount16 population_count2(in[47:32], count2);
    PopulationCount16 population_count3(in[63:48], count3);
    PopulationCount16 population_count4(in[79:64], count4);
    PopulationCount16 population_count5(in[95:80], count5);
    PopulationCount16 population_count6(in[111:96], count6);
    PopulationCount16 population_count7(in[127:112], count7);
    PopulationCount16 population_count8(in[143:128], count8);
    PopulationCount16 population_count9(in[159:144], count9);
    PopulationCount16 population_count10(in[175:160], count10);
    PopulationCount16 population_count11(in[191:176], count11);
    PopulationCount16 population_count12(in[207:192], count12);
    PopulationCount16 population_count13(in[223:208], count13);
    PopulationCount16 population_count14(in[239:224], count14);
    PopulationCount16 population_count15(in[255:240], count15);

    // Add up the counts
    wire [7:0] sum0, sum1, sum2, sum3, sum4, sum5, sum6, sum7;
    FullAdder8 fa0(count0, count1, 8'b0, sum0);
    FullAdder8 fa1(count2, count3, 8'b0, sum1);
    FullAdder8 fa2(count4, count5, 8'b0, sum2);
    FullAdder8 fa3(count6, count7, 8'b0, sum3);
    FullAdder8 fa4(count8, count9, 8'b0, sum4);
    FullAdder8 fa5(count10, count11, 8'b0, sum5);
    FullAdder8 fa6(count12, count13, 8'b0, sum6);
    FullAdder8 fa7(count14, count15, 8'b0, sum7);

    wire [7:0] sum8, sum9, sum10, sum11;
    FullAdder8 fa8(sum0, sum1, 8'b0, sum8);
    FullAdder8 fa9(sum2, sum3, 8'b0, sum9);
    FullAdder8 fa10(sum4, sum5, 8'b0, sum10);
    FullAdder8 fa11(sum6, sum7, 8'b0, sum11);

    wire [7:0] sum12, sum13;
    FullAdder8 fa12(sum8, sum9, 8'b0, sum12);
    FullAdder8 fa13(sum10, sum11, 8'b0, sum13);

    wire [7:0] sum14;
    FullAdder8 fa14(sum12, sum13, 8'b0, sum14);

    assign out = sum14;

endmodule

module PopulationCount16(
    input [15:0] in,
    output [3:0] out
);

    wire [3:0] count0, count1, count2, count3;

    // Count the number of '1's in each group of 4 bits
    PopulationCount4 population_count0(in[3:0], count0);
    PopulationCount4 population_count1(in[7:4], count1);
    PopulationCount4 population_count2(in[11:8], count2);
    PopulationCount4 population_count3(in[15:12], count3);

    // Add up the counts
    wire [3:0] sum0, sum1;
    FullAdder4 fa0(count0, count1, 4'b0, sum0);
    FullAdder4 fa1(count2, count3, 4'b0, sum1);

    wire [3:0] sum2;
    FullAdder4 fa2(sum0, sum1, 4'b0, sum2);

    assign out = sum2;

endmodule

module PopulationCount4(
    input [3:0] in,
    output [1:0] out
);

    assign out = {1'b0, (in[3] | in[2]) + (in[1] | in[0])};

endmodule

module FullAdder4(
    input [3:0] a,
    input [3:0] b,
    input [3:0] cin,
    output [3:0] sum
);

    assign sum = a + b + cin;

endmodule

module FullAdder8(
    input [7:0] a,
    input [7:0] b,
    input [7:0] cin,
    output [7:0] sum
);

    assign sum = a + b + cin;

endmodule