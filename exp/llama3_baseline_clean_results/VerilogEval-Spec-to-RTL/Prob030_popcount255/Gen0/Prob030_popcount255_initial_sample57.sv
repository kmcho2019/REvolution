module TopModule(
    input  [254:0] in,
    output [7:0] out
);

    wire [7:0] partial_count_0;
    wire [7:0] partial_count_1;
    wire [7:0] partial_count_2;
    wire [7:0] partial_count_3;
    wire [7:0] partial_count_4;
    wire [7:0] partial_count_5;
    wire [7:0] partial_count_6;
    wire [7:0] partial_count_7;

    PopulationCount32 pc_0(.in(in[ 31: 0]), .out(partial_count_0));
    PopulationCount32 pc_1(.in(in[ 63:32]), .out(partial_count_1));
    PopulationCount32 pc_2(.in(in[ 95:64]), .out(partial_count_2));
    PopulationCount32 pc_3(.in(in[127:96]), .out(partial_count_3));
    PopulationCount32 pc_4(.in(in[159:128]), .out(partial_count_4));
    PopulationCount32 pc_5(.in(in[191:160]), .out(partial_count_5));
    PopulationCount32 pc_6(.in(in[223:192]), .out(partial_count_6));
    PopulationCount32 pc_7(.in({in[254:224], 7'b0}), .out(partial_count_7));

    Adder8bit add_0(.in0(partial_count_0), .in1(partial_count_1), .out(out));
    Adder8bit add_1(.in0(partial_count_2), .in1(partial_count_3), .out(partial_count_2));
    Adder8bit add_2(.in0(partial_count_4), .in1(partial_count_5), .out(partial_count_4));
    Adder8bit add_3(.in0(partial_count_6), .in1(partial_count_7), .out(partial_count_6));

    Adder8bit add_4(.in0(partial_count_2), .in1(partial_count_4), .out(partial_count_2));
    Adder8bit add_5(.in0(partial_count_6), .in1(out), .out(out));

endmodule

module PopulationCount32(
    input  [31:0] in,
    output [7:0] out
);

    // this can be further divided using the same technique as above
    // here we will assume it is implemented directly
    assign out = {8{1'b0}} + 
                 in[ 0] + in[ 1] + in[ 2] + in[ 3] + in[ 4] + in[ 5] + in[ 6] + in[ 7] +
                 in[ 8] + in[ 9] + in[10] + in[11] + in[12] + in[13] + in[14] + in[15] +
                 in[16] + in[17] + in[18] + in[19] + in[20] + in[21] + in[22] + in[23] +
                 in[24] + in[25] + in[26] + in[27] + in[28] + in[29] + in[30] + in[31];

endmodule

module Adder8bit(
    input  [7:0] in0,
    input  [7:0] in1,
    output [7:0] out
);

    assign out = in0 + in1;

endmodule