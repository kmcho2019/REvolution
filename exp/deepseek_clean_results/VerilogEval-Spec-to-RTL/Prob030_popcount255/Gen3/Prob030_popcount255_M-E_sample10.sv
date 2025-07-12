module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

// Stage 1: Count 1s in 15-bit groups (17 groups)
wire [3:0] group_counts [0:16];
genvar i;
generate
    for (i = 0; i < 17; i = i + 1) begin : GROUP_COUNTERS
        // Count 1s in each 15-bit group (or less for last group)
        wire [14:0] group = (i == 16) ? {9'b0, in[254:248]} : in[i*15 +: 15];
        assign group_counts[i] = group[0] + group[1] + group[2] + group[3] + 
                               group[4] + group[5] + group[6] + group[7] + 
                               group[8] + group[9] + group[10] + group[11] + 
                               group[12] + group[13] + group[14];
    end
endgenerate

// Stage 2: Balanced binary tree of carry-save adders
// First level: 9 adders (17 -> 9)
wire [4:0] level1 [0:8];
generate
    for (i = 0; i < 8; i = i + 1) begin : LEVEL1
        assign level1[i] = group_counts[i*2] + group_counts[i*2+1];
    end
    assign level1[8] = group_counts[16];
endgenerate

// Second level: 5 adders (9 -> 5)
wire [5:0] level2 [0:4];
generate
    for (i = 0; i < 4; i = i + 1) begin : LEVEL2
        assign level2[i] = level1[i*2] + level1[i*2+1];
    end
    assign level2[4] = level1[8];
endgenerate

// Third level: 3 adders (5 -> 3)
wire [6:0] level3 [0:2];
generate
    for (i = 0; i < 2; i = i + 1) begin : LEVEL3
        assign level3[i] = level2[i*2] + level2[i*2+1];
    end
    assign level3[2] = level2[4];
endgenerate

// Final level: 2 adders (3 -> 2)
wire [7:0] level4 [0:1];
assign level4[0] = level3[0] + level3[1];
assign level4[1] = level3[2];

// Final sum
assign out = level4[0] + level4[1];

endmodule