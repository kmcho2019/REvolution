module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

// First level: count 1s in each 3-bit group (85 groups)
wire [1:0] level1 [0:84];
genvar i;
generate
    for (i = 0; i < 85; i = i + 1) begin : level1_count
        assign level1[i] = in[i*3] + in[i*3+1] + in[i*3+2];
    end
endgenerate

// Second level: sum 85 2-bit counts (85*2=170 bits)
// We'll sum them in groups of 4 to reduce the number of additions
wire [3:0] level2 [0:21]; // 85/4=21.25 -> 22 groups (last group has 1 count)
generate
    for (i = 0; i < 21; i = i + 1) begin : level2_sum
        assign level2[i] = level1[i*4] + level1[i*4+1] + level1[i*4+2] + level1[i*4+3];
    end
    // Handle the remaining group (85 - 21*4 = 1 count)
    assign level2[21] = level1[84];
endgenerate

// Third level: sum 22 4-bit counts (22*4=88 bits)
// Sum in groups of 4 again
wire [5:0] level3 [0:5]; // 22/4=5.5 -> 6 groups
generate
    for (i = 0; i < 5; i = i + 1) begin : level3_sum
        assign level3[i] = level2[i*4] + level2[i*4+1] + level2[i*4+2] + level2[i*4+3];
    end
    // Handle remaining groups (22 - 5*4 = 2 counts)
    assign level3[5] = level2[20] + level2[21];
endgenerate

// Fourth level: sum 6 6-bit counts
wire [7:0] level4 [0:1]; // 6/4=1.5 -> 2 groups
assign level4[0] = level3[0] + level3[1] + level3[2] + level3[3];
assign level4[1] = level3[4] + level3[5];

// Final sum
assign out = level4[0] + level4[1];

endmodule