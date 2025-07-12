module TopModule (
    input  [254:0] in,
    output [7:0] out
);

// Divide the input into nine segments of 28 bits
reg [27:0] segment [8:0];

// Population count for each segment
reg [5:0] segment_count [8:0];

// First level of the population count tree
reg [5:0] level1_count [2:0];

// Second level of the population count tree
reg [6:0] level2_count [0:0];

// Final count
reg [7:0] count;

always @(*) begin
    // Initialize counts
    for (int i = 0; i < 9; i++) begin
        segment_count[i] = 6'd0;
    end
    
    // Divide the input into segments
    for (int i = 0; i < 9; i++) begin
        if (i == 8) begin
            segment[i] = {9'd0, in[(i*28)+:19]};
        end else begin
            segment[i] = in[(i*28)+:28];
        end
    end
    
    // Population count for each segment
    for (int i = 0; i < 9; i++) begin
        for (int j = 0; j < 28; j++) begin
            if (segment[i][j]) begin
                segment_count[i] = segment_count[i] + 1;
            end
        end
    end
    
    // First level of the population count tree
    level1_count[0] = segment_count[0] + segment_count[1] + segment_count[2];
    level1_count[1] = segment_count[3] + segment_count[4] + segment_count[5];
    level1_count[2] = segment_count[6] + segment_count[7] + segment_count[8];
    
    // Second level of the population count tree
    level2_count[0] = level1_count[0] + level1_count[1] + level1_count[2];
    
    // Final count
    count = level2_count[0][6:0];
end

assign out = count;

endmodule