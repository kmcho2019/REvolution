module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Divide the input into 32 segments of 8 bits
wire [7:0] segment [31:0];

// Assign the segments using generate
genvar i;
generate
    for (i = 0; i < 32; i++) begin
        if (i < 31) begin
            assign segment[i] = in[i*8 +: 8];
        end else begin
            assign segment[i] = {1'b0, in[254:248]};
        end
    end
endgenerate

// Population counts for each segment
wire [4:0] segment_count [31:0];

// Assign the population counts using generate
generate
    for (i = 0; i < 32; i++) begin
        assign segment_count[i] = $countones(segment[i]);
    end
endgenerate

// Final population count using a tree-like structure of adders
wire [7:0] count;

// Level 1: Add pairs of segment counts
wire [5:0] level1_count [15:0];
generate
    for (i = 0; i < 16; i++) begin
        assign level1_count[i] = segment_count[i*2] + segment_count[i*2 + 1];
    end
endgenerate

// Level 2: Add pairs of level1 counts
wire [6:0] level2_count [7:0];
generate
    for (i = 0; i < 8; i++) begin
        assign level2_count[i] = level1_count[i*2] + level1_count[i*2 + 1];
    end
endgenerate

// Level 3: Add pairs of level2 counts
wire [7:0] level3_count [3:0];
generate
    for (i = 0; i < 4; i++) begin
        assign level3_count[i] = level2_count[i*2] + level2_count[i*2 + 1];
    end
endgenerate

// Level 4: Add pairs of level3 counts
wire [7:0] level4_count [1:0];
generate
    for (i = 0; i < 2; i++) begin
        assign level4_count[i] = level3_count[i*2] + level3_count[i*2 + 1];
    end
endgenerate

// Final count
assign count = level4_count[0] + level4_count[1];

// Assign the output
assign out = count;

endmodule