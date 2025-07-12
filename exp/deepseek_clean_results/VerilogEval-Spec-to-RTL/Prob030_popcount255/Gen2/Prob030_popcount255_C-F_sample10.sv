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

// Second level: sum in binary tree fashion
// First stage: sum pairs of level1 counts (43 sums)
wire [2:0] level2 [0:42];
generate
    for (i = 0; i < 42; i = i + 1) begin : level2_sum
        assign level2[i] = level1[i*2] + level1[i*2+1];
    end
    // Handle odd count
    assign level2[42] = level1[84];
endgenerate

// Third level: sum pairs of level2 counts (22 sums)
wire [3:0] level3 [0:21];
generate
    for (i = 0; i < 21; i = i + 1) begin : level3_sum
        assign level3[i] = level2[i*2] + level2[i*2+1];
    end
    // Handle odd count
    assign level3[21] = level2[42];
endgenerate

// Fourth level: sum pairs of level3 counts (11 sums)
wire [4:0] level4 [0:10];
generate
    for (i = 0; i < 10; i = i + 1) begin : level4_sum
        assign level4[i] = level3[i*2] + level3[i*2+1];
    end
    // Handle odd count
    assign level4[10] = level3[21];
endgenerate

// Fifth level: sum pairs of level4 counts (6 sums)
wire [5:0] level5 [0:5];
generate
    for (i = 0; i < 5; i = i + 1) begin : level5_sum
        assign level5[i] = level4[i*2] + level4[i*2+1];
    end
    // Handle odd count
    assign level5[5] = level4[10];
endgenerate

// Sixth level: sum pairs of level5 counts (3 sums)
wire [6:0] level6 [0:2];
assign level6[0] = level5[0] + level5[1];
assign level6[1] = level5[2] + level5[3];
assign level6[2] = level5[4] + level5[5];

// Final sum
assign out = level6[0] + level6[1] + level6[2];

endmodule