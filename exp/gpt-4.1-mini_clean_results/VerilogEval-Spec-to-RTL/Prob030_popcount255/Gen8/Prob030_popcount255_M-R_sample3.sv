module popcount17 (
    input  [16:0] in,
    output [5:0] out // 6 bits for sum up to 17
);
    // Level 1: sum pairs of bits
    wire [1:0] s0, s1, s2, s3, s4, s5, s6, s7;
    assign s0 = in[0] + in[1];
    assign s1 = in[2] + in[3];
    assign s2 = in[4] + in[5];
    assign s3 = in[6] + in[7];
    assign s4 = in[8] + in[9];
    assign s5 = in[10] + in[11];
    assign s6 = in[12] + in[13];
    assign s7 = in[14] + in[15];
    wire leftover = in[16];

    // Level 2: sum pairs of 2-bit values
    wire [2:0] s8  = s0 + s1;
    wire [2:0] s9  = s2 + s3;
    wire [2:0] s10 = s4 + s5;
    wire [2:0] s11 = s6 + s7;

    // Level 3: sum pairs of 3-bit values
    wire [3:0] s12 = s8 + s9;
    wire [3:0] s13 = s10 + s11;

    // Level 4: sum two 4-bit values
    wire [4:0] s14 = s12 + s13;

    // Add leftover bit
    assign out = s14 + leftover;

endmodule


module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Partition input into 15 groups of 17 bits each
    wire [5:0] partial_counts [0:14];

    // Instantiate popcount17 for each group explicitly without generate
    popcount17 pc0 (.in(in[16:0]),     .out(partial_counts[0]));
    popcount17 pc1 (.in(in[33:17]),    .out(partial_counts[1]));
    popcount17 pc2 (.in(in[50:34]),    .out(partial_counts[2]));
    popcount17 pc3 (.in(in[67:51]),    .out(partial_counts[3]));
    popcount17 pc4 (.in(in[84:68]),    .out(partial_counts[4]));
    popcount17 pc5 (.in(in[101:85]),   .out(partial_counts[5]));
    popcount17 pc6 (.in(in[118:102]),  .out(partial_counts[6]));
    popcount17 pc7 (.in(in[135:119]),  .out(partial_counts[7]));
    popcount17 pc8 (.in(in[152:136]),  .out(partial_counts[8]));
    popcount17 pc9 (.in(in[169:153]),  .out(partial_counts[9]));
    popcount17 pc10(.in(in[186:170]),  .out(partial_counts[10]));
    popcount17 pc11(.in(in[203:187]),  .out(partial_counts[11]));
    popcount17 pc12(.in(in[220:204]),  .out(partial_counts[12]));
    popcount17 pc13(.in(in[237:221]),  .out(partial_counts[13]));
    popcount17 pc14(.in(in[254:238]),  .out(partial_counts[14]));

    // Stage 1: Sum pairs of partial_counts (zero-extend to 8 bits)
    wire [7:0] s1_0 = {2'b00, partial_counts[0]} + {2'b00, partial_counts[1]};
    wire [7:0] s1_1 = {2'b00, partial_counts[2]} + {2'b00, partial_counts[3]};
    wire [7:0] s1_2 = {2'b00, partial_counts[4]} + {2'b00, partial_counts[5]};
    wire [7:0] s1_3 = {2'b00, partial_counts[6]} + {2'b00, partial_counts[7]};
    wire [7:0] s1_4 = {2'b00, partial_counts[8]} + {2'b00, partial_counts[9]};
    wire [7:0] s1_5 = {2'b00, partial_counts[10]} + {2'b00, partial_counts[11]};
    wire [7:0] s1_6 = {2'b00, partial_counts[12]} + {2'b00, partial_counts[13]};
    wire [7:0] s1_7 = {2'b00, partial_counts[14]}; // lone partial count

    // Stage 2: sum pairs
    wire [7:0] s2_0 = s1_0 + s1_1;
    wire [7:0] s2_1 = s1_2 + s1_3;
    wire [7:0] s2_2 = s1_4 + s1_5;
    wire [7:0] s2_3 = s1_6 + s1_7;

    // Stage 3: sum pairs
    wire [7:0] s3_0 = s2_0 + s2_1;
    wire [7:0] s3_1 = s2_2 + s2_3;

    // Final output: sum remaining two
    assign out = s3_0 + s3_1;

endmodule