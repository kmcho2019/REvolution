module TopModule(
    input [254:0] in,
    output [7:0] out
);

wire [7:0] count0, count1, count2, count3;

// Divide the input vector into 4 chunks of 64 bits (with 7 bits unused)
// and calculate the population count for each chunk
PopulationCount64 population_count0(in[ 63:  0], count0);
PopulationCount64 population_count1(in[127: 64], count1);
PopulationCount64 population_count2(in[191:128], count2);
PopulationCount64 population_count3(in[254:192], count3);

// Combine the population counts using adders
assign out = count0 + count1 + count2 + count3;

endmodule

module PopulationCount64(
    input [63:0] in,
    output [6:0] out
);

wire [6:0] count0, count1;

// Divide the input vector into 2 chunks of 32 bits and calculate the population count for each chunk
PopulationCount32 population_count0(in[31:0], count0);
PopulationCount32 population_count1(in[63:32], count1);

// Combine the population counts using an adder
assign out = count0 + count1;

endmodule

module PopulationCount32(
    input [31:0] in,
    output [5:0] out
);

wire [5:0] count0, count1;

// Divide the input vector into 2 chunks of 16 bits and calculate the population count for each chunk
PopulationCount16 population_count0(in[15:0], count0);
PopulationCount16 population_count1(in[31:16], count1);

// Combine the population counts using an adder
assign out = count0 + count1;

endmodule

module PopulationCount16(
    input [15:0] in,
    output [4:0] out
);

wire [4:0] count0, count1;

// Divide the input vector into 2 chunks of 8 bits and calculate the population count for each chunk
PopulationCount8 population_count0(in[7:0], count0);
PopulationCount8 population_count1(in[15:8], count1);

// Combine the population counts using an adder
assign out = count0 + count1;

endmodule

module PopulationCount8(
    input [7:0] in,
    output [3:0] out
);

// Use the $countones function to calculate the population count
assign out = $countones(in);

endmodule