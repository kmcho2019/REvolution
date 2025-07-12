module TopModule(
    input [254:0] in,
    output [7:0] out
);

wire [7:0] count0, count1, count2, count3, count4, count5, count6, count7;
wire [7:0] sum0, sum1, sum2, sum3;

// Divide the input vector into 8 chunks of 32 bits (with 7 bits unused)
// and calculate the population count for each chunk
PopulationCount32 population_count0(in[ 31:  0], count0);
PopulationCount32 population_count1(in[ 63: 32], count1);
PopulationCount32 population_count2(in[ 95: 64], count2);
PopulationCount32 population_count3(in[127: 96], count3);
PopulationCount32 population_count4(in[159:128], count4);
PopulationCount32 population_count5(in[191:160], count5);
PopulationCount32 population_count6(in[223:192], count6);
PopulationCount32 population_count7(in[254:224], count7);

// Combine the population counts using adders
assign sum0 = count0 + count1;
assign sum1 = count2 + count3;
assign sum2 = count4 + count5;
assign sum3 = count6 + count7;

// Final addition to produce the 8-bit result
assign out = sum0 + sum1 + sum2 + sum3;

endmodule

module PopulationCount32(
    input [31:0] in,
    output [5:0] out
);

wire [5:0] count0, count1, count2, count3;

// Divide the input vector into 4 chunks of 8 bits and calculate the population count for each chunk
PopulationCount8 population_count0(in[ 7: 0], count0);
PopulationCount8 population_count1(in[15: 8], count1);
PopulationCount8 population_count2(in[23:16], count2);
PopulationCount8 population_count3(in[31:24], count3);

// Combine the population counts using adders
assign out = count0 + count1 + count2 + count3;

endmodule

module PopulationCount8(
    input [7:0] in,
    output [3:0] out
);

wire [3:0] count0, count1;

// Divide the input vector into 2 chunks of 4 bits and calculate the population count for each chunk
PopulationCount4 population_count0(in[3:0], count0);
PopulationCount4 population_count1(in[7:4], count1);

// Combine the population counts using an adder
assign out = count0 + count1;

endmodule

module PopulationCount4(
    input [3:0] in,
    output [2:0] out
);

wire [1:0] count0, count1;

// Divide the input vector into 2 chunks of 2 bits and calculate the population count for each chunk
PopulationCount2 population_count0(in[1:0], count0);
PopulationCount2 population_count1(in[3:2], count1);

// Combine the population counts using an adder
assign out = {1'b0, count0} + {1'b0, count1};

endmodule

module PopulationCount2(
    input [1:0] in,
    output [1:0] out
);

// Calculate the population count for the 2-bit input vector
assign out = (in[0] ? 1 : 0) + (in[1] ? 1 : 0);

endmodule