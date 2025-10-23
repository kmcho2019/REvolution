module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Divide the input into 255 segments of 1 bit
wire [0:0] segment [254:0];

// Assign the segments
genvar i;
generate
    for (i = 0; i < 255; i++) begin
        assign segment[i] = in[i];
    end
endgenerate

// Population counts for each segment
wire [7:0] segment_count [254:0];

// Assign the population counts using a generate block
generate
    for (genvar j = 0; j < 255; j++) begin
        assign segment_count[j] = $countones({8{segment[j]}});
    end
endgenerate

// Create a binary tree structure to sum the population counts
wire [7:0] level1_count [127:0];
wire [7:0] level2_count [63:0];
wire [7:0] level3_count [31:0];
wire [7:0] level4_count [15:0];
wire [7:0] level5_count [7:0];
wire [7:0] level6_count [3:0];
wire [7:0] level7_count [1:0];
wire [7:0] level8_count [0:0];

// Level 1
generate
    for (genvar k = 0; k < 128; k++) begin
        assign level1_count[k] = segment_count[k*2] + segment_count[k*2 + 1];
    end
endgenerate

// Level 2
generate
    for (genvar l = 0; l < 64; l++) begin
        assign level2_count[l] = level1_count[l*2] + level1_count[l*2 + 1];
    end
endgenerate

// Level 3
generate
    for (genvar m = 0; m < 32; m++) begin
        assign level3_count[m] = level2_count[m*2] + level2_count[m*2 + 1];
    end
endgenerate

// Level 4
generate
    for (genvar n = 0; n < 16; n++) begin
        assign level4_count[n] = level3_count[n*2] + level3_count[n*2 + 1];
    end
endgenerate

// Level 5
generate
    for (genvar o = 0; o < 8; o++) begin
        assign level5_count[o] = level4_count[o*2] + level4_count[o*2 + 1];
    end
endgenerate

// Level 6
generate
    for (genvar p = 0; p < 4; p++) begin
        assign level6_count[p] = level5_count[p*2] + level5_count[p*2 + 1];
    end
endgenerate

// Level 7
generate
    for (genvar q = 0; q < 2; q++) begin
        assign level7_count[q] = level6_count[q*2] + level6_count[q*2 + 1];
    end
endgenerate

// Level 8
assign level8_count[0] = level7_count[0] + level7_count[1];

// Assign the output
assign out = level8_count[0];

endmodule