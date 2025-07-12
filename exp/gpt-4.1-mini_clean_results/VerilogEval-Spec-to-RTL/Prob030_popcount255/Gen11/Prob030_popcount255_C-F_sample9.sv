module popcount17 (
    input  [16:0] in,
    output [5:0] out // 6 bits to cover max 17 ones safely
);
    // Level 1: sum pairs of bits explicitly (8 sums)
    wire [1:0] s0 = in[0] + in[1];
    wire [1:0] s1 = in[2] + in[3];
    wire [1:0] s2 = in[4] + in[5];
    wire [1:0] s3 = in[6] + in[7];
    wire [1:0] s4 = in[8] + in[9];
    wire [1:0] s5 = in[10] + in[11];
    wire [1:0] s6 = in[12] + in[13];
    wire [1:0] s7 = in[14] + in[15];
    wire leftover = in[16];

    // Level 2: sum pairs of 2-bit results (4 sums)
    wire [2:0] s8  = s0 + s1;
    wire [2:0] s9  = s2 + s3;
    wire [2:0] s10 = s4 + s5;
    wire [2:0] s11 = s6 + s7;

    // Level 3: sum pairs of 3-bit results (2 sums)
    wire [3:0] s12 = s8 + s9;
    wire [3:0] s13 = s10 + s11;

    // Level 4: sum two 4-bit results (1 sum)
    wire [4:0] s14 = s12 + s13;

    // Add leftover bit (1 bit)
    assign out = s14 + leftover;

endmodule


module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Instantiate 15 popcount17 modules explicitly, no generate loops for clarity
    wire [5:0] pc_counts [14:0];

    popcount17 pc0  (.in(in[16:0]),     .out(pc_counts[0]));
    popcount17 pc1  (.in(in[33:17]),    .out(pc_counts[1]));
    popcount17 pc2  (.in(in[50:34]),    .out(pc_counts[2]));
    popcount17 pc3  (.in(in[67:51]),    .out(pc_counts[3]));
    popcount17 pc4  (.in(in[84:68]),    .out(pc_counts[4]));
    popcount17 pc5  (.in(in[101:85]),   .out(pc_counts[5]));
    popcount17 pc6  (.in(in[118:102]),  .out(pc_counts[6]));
    popcount17 pc7  (.in(in[135:119]),  .out(pc_counts[7]));
    popcount17 pc8  (.in(in[152:136]),  .out(pc_counts[8]));
    popcount17 pc9  (.in(in[169:153]),  .out(pc_counts[9]));
    popcount17 pc10 (.in(in[186:170]),  .out(pc_counts[10]));
    popcount17 pc11 (.in(in[203:187]),  .out(pc_counts[11]));
    popcount17 pc12 (.in(in[220:204]),  .out(pc_counts[12]));
    popcount17 pc13 (.in(in[237:221]),  .out(pc_counts[13]));
    popcount17 pc14 (.in(in[254:238]),  .out(pc_counts[14]));

    // Level 1 sum: add pairs of partial counts, zero-extended to 8 bits
    wire [7:0] s1_0 = {2'b00, pc_counts[0]} + {2'b00, pc_counts[1]};
    wire [7:0] s1_1 = {2'b00, pc_counts[2]} + {2'b00, pc_counts[3]};
    wire [7:0] s1_2 = {2'b00, pc_counts[4]} + {2'b00, pc_counts[5]};
    wire [7:0] s1_3 = {2'b00, pc_counts[6]} + {2'b00, pc_counts[7]};
    wire [7:0] s1_4 = {2'b00, pc_counts[8]} + {2'b00, pc_counts[9]};
    wire [7:0] s1_5 = {2'b00, pc_counts[10]} + {2'b00, pc_counts[11]};
    wire [7:0] s1_6 = {2'b00, pc_counts[12]} + {2'b00, pc_counts[13]};
    wire [7:0] s1_7 = {2'b00, pc_counts[14]}; // last one unpaired

    // Level 2 sum: add pairs from level 1
    wire [7:0] s2_0 = s1_0 + s1_1;
    wire [7:0] s2_1 = s1_2 + s1_3;
    wire [7:0] s2_2 = s1_4 + s1_5;
    wire [7:0] s2_3 = s1_6 + s1_7;

    // Level 3 sum: add pairs from level 2
    wire [7:0] s3_0 = s2_0 + s2_1;
    wire [7:0] s3_1 = s2_2 + s2_3;

    // Final sum
    assign out = s3_0 + s3_1;

endmodule