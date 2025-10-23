module TopModule(
    input  [254:0] in,
    output [7:0] out
);

    wire [7:0] count_16_0;
    wire [7:0] count_16_1;
    wire [7:0] count_16_2;
    wire [7:0] count_16_3;
    wire [7:0] count_16_4;
    wire [7:0] count_16_5;
    wire [7:0] count_16_6;
    wire [7:0] count_16_7;
    wire [7:0] count_16_8;
    wire [7:0] count_16_9;
    wire [7:0] count_16_10;
    wire [7:0] count_16_11;
    wire [7:0] count_16_12;
    wire [7:0] count_16_13;
    wire [7:0] count_16_14;
    wire [7:0] count_16_15;

    wire [7:0] count_16_0_1;
    wire [7:0] count_16_2_3;
    wire [7:0] count_16_4_5;
    wire [7:0] count_16_6_7;
    wire [7:0] count_16_8_9;
    wire [7:0] count_16_10_11;
    wire [7:0] count_16_12_13;
    wire [7:0] count_16_14_15;

    wire [7:0] count_16_0_3;
    wire [7:0] count_16_4_7;
    wire [7:0] count_16_8_11;
    wire [7:0] count_16_12_15;

    wire [7:0] count_16_0_7;
    wire [7:0] count_16_8_15;

    PopulationCount16bit populationCount16bit_0 (
       .in(in[15:0]),
       .out(count_16_0)
    );

    PopulationCount16bit populationCount16bit_1 (
       .in(in[31:16]),
       .out(count_16_1)
    );

    PopulationCount16bit populationCount16bit_2 (
       .in(in[47:32]),
       .out(count_16_2)
    );

    PopulationCount16bit populationCount16bit_3 (
       .in(in[63:48]),
       .out(count_16_3)
    );

    PopulationCount16bit populationCount16bit_4 (
       .in(in[79:64]),
       .out(count_16_4)
    );

    PopulationCount16bit populationCount16bit_5 (
       .in(in[95:80]),
       .out(count_16_5)
    );

    PopulationCount16bit populationCount16bit_6 (
       .in(in[111:96]),
       .out(count_16_6)
    );

    PopulationCount16bit populationCount16bit_7 (
       .in(in[127:112]),
       .out(count_16_7)
    );

    PopulationCount16bit populationCount16bit_8 (
       .in(in[143:128]),
       .out(count_16_8)
    );

    PopulationCount16bit populationCount16bit_9 (
       .in(in[159:144]),
       .out(count_16_9)
    );

    PopulationCount16bit populationCount16bit_10 (
       .in(in[175:160]),
       .out(count_16_10)
    );

    PopulationCount16bit populationCount16bit_11 (
       .in(in[191:176]),
       .out(count_16_11)
    );

    PopulationCount16bit populationCount16bit_12 (
       .in(in[207:192]),
       .out(count_16_12)
    );

    PopulationCount16bit populationCount16bit_13 (
       .in(in[223:208]),
       .out(count_16_13)
    );

    PopulationCount16bit populationCount16bit_14 (
       .in(in[239:224]),
       .out(count_16_14)
    );

    PopulationCount16bit populationCount16bit_15 (
       .in(in[254:240]),
       .out(count_16_15)
    );

    FullAdder8bit fullAdder8bit_0_1 (
       .in1(count_16_0),
       .in2(count_16_1),
       .out(count_16_0_1)
    );

    FullAdder8bit fullAdder8bit_2_3 (
       .in1(count_16_2),
       .in2(count_16_3),
       .out(count_16_2_3)
    );

    FullAdder8bit fullAdder8bit_4_5 (
       .in1(count_16_4),
       .in2(count_16_5),
       .out(count_16_4_5)
    );

    FullAdder8bit fullAdder8bit_6_7 (
       .in1(count_16_6),
       .in2(count_16_7),
       .out(count_16_6_7)
    );

    FullAdder8bit fullAdder8bit_8_9 (
       .in1(count_16_8),
       .in2(count_16_9),
       .out(count_16_8_9)
    );

    FullAdder8bit fullAdder8bit_10_11 (
       .in1(count_16_10),
       .in2(count_16_11),
       .out(count_16_10_11)
    );

    FullAdder8bit fullAdder8bit_12_13 (
       .in1(count_16_12),
       .in2(count_16_13),
       .out(count_16_12_13)
    );

    FullAdder8bit fullAdder8bit_14_15 (
       .in1(count_16_14),
       .in2(count_16_15),
       .out(count_16_14_15)
    );

    FullAdder8bit fullAdder8bit_0_3 (
       .in1(count_16_0_1),
       .in2(count_16_2_3),
       .out(count_16_0_3)
    );

    FullAdder8bit fullAdder8bit_4_7 (
       .in1(count_16_4_5),
       .in2(count_16_6_7),
       .out(count_16_4_7)
    );

    FullAdder8bit fullAdder8bit_8_11 (
       .in1(count_16_8_9),
       .in2(count_16_10_11),
       .out(count_16_8_11)
    );

    FullAdder8bit fullAdder8bit_12_15 (
       .in1(count_16_12_13),
       .in2(count_16_14_15),
       .out(count_16_12_15)
    );

    FullAdder8bit fullAdder8bit_0_7 (
       .in1(count_16_0_3),
       .in2(count_16_4_7),
       .out(count_16_0_7)
    );

    FullAdder8bit fullAdder8bit_8_15 (
       .in1(count_16_8_11),
       .in2(count_16_12_15),
       .out(count_16_8_15)
    );

    FullAdder8bit fullAdder8bit_final (
       .in1(count_16_0_7),
       .in2(count_16_8_15),
       .out(out)
    );

endmodule

module PopulationCount16bit(
    input  [15:0] in,
    output [7:0] out
);

    wire [3:0] count_4_0;
    wire [3:0] count_4_1;
    wire [3:0] count_4_2;
    wire [3:0] count_4_3;

    PopulationCount4bit populationCount4bit_0 (
       .in(in[3:0]),
       .out(count_4_0)
    );

    PopulationCount4bit populationCount4bit_1 (
       .in(in[7:4]),
       .out(count_4_1)
    );

    PopulationCount4bit populationCount4bit_2 (
       .in(in[11:8]),
       .out(count_4_2)
    );

    PopulationCount4bit populationCount4bit_3 (
       .in(in[15:12]),
       .out(count_4_3)
    );

    FullAdder4bit fullAdder4bit_0_1 (
       .in1(count_4_0),
       .in2(count_4_1),
       .out(out[3:0])
    );

    FullAdder4bit fullAdder4bit_2_3 (
       .in1(count_4_2),
       .in2(count_4_3),
       .out(out[7:4])
    );

endmodule

module PopulationCount4bit(
    input  [3:0] in,
    output [3:0] out
);

    assign out[0] = in[0];
    assign out[1] = in[1];
    assign out[2] = in[2];
    assign out[3] = in[3];

endmodule

module FullAdder8bit(
    input  [7:0] in1,
    input  [7:0] in2,
    output [7:0] out
);

    assign out = in1 + in2;

endmodule

module FullAdder4bit(
    input  [3:0] in1,
    input  [3:0] in2,
    output [3:0] out
);

    assign out = in1 + in2;

endmodule