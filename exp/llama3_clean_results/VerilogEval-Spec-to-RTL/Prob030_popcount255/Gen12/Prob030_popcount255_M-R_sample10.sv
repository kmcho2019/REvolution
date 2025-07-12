module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Divide the input into 32 segments of 8 bits
reg [7:0] segment [31:0];

// Population counts for each segment
reg [4:0] segment_count [31:0];

// Final population count using a tree-like structure of adders
reg [7:0] count;

// Assign the segments
always @(*) begin
    for (int i = 0; i < 32; i++) begin
        if (i < 31) begin
            segment[i] = in[(i * 8) +: 8];
        end else begin
            segment[i] = {1'b0, in[254 -: 7]};
        end
    end
end

// Assign the population counts
always @(*) begin
    for (int i = 0; i < 32; i++) begin
        segment_count[i] = $countones(segment[i]);
    end
end

// Final population count using a tree-like structure of adders
always @(*) begin
    reg [7:0] level1_count [15:0];
    reg [7:0] level2_count [7:0];
    reg [7:0] level3_count [3:0];
    reg [7:0] level4_count [1:0];

    // Level 1: Add pairs of segment counts
    for (int i = 0; i < 16; i++) begin
        level1_count[i] = segment_count[i * 2] + segment_count[i * 2 + 1];
    end

    // Level 2: Add pairs of level1 counts
    for (int i = 0; i < 8; i++) begin
        level2_count[i] = level1_count[i * 2] + level1_count[i * 2 + 1];
    end

    // Level 3: Add pairs of level2 counts
    for (int i = 0; i < 4; i++) begin
        level3_count[i] = level2_count[i * 2] + level2_count[i * 2 + 1];
    end

    // Level 4: Add pairs of level3 counts
    for (int i = 0; i < 2; i++) begin
        level4_count[i] = level3_count[i * 2] + level3_count[i * 2 + 1];
    end

    // Final count
    count = level4_count[0] + level4_count[1];
end

// Assign the output
assign out = count;

endmodule