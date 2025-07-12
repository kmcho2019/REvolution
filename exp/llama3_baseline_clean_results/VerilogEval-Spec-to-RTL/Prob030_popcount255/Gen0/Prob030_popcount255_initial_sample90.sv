module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Hierarchical population count
reg [7:0] count;

// Level 1: 1-bit counters (255 counters)
reg [7:0] level1_count [0:254];

// Initialize all counters to 0
integer i;
always @(in) begin
    for (i = 0; i < 255; i = i + 1) begin
        if (in[i]) begin
            level1_count[i] = 1;
        end else begin
            level1_count[i] = 0;
        end
    end

    // Level 2: 2-bit counters (128 counters)
    reg [7:0] level2_count [0:127];
    for (i = 0; i < 128; i = i + 1) begin
        level2_count[i] = level1_count[i*2] + level1_count[i*2+1];
    end

    // Level 3: 4-bit counters (64 counters)
    reg [7:0] level3_count [0:63];
    for (i = 0; i < 64; i = i + 1) begin
        level3_count[i] = level2_count[i*2] + level2_count[i*2+1];
    end

    // Level 4: 8-bit counters (32 counters)
    reg [7:0] level4_count [0:31];
    for (i = 0; i < 32; i = i + 1) begin
        level4_count[i] = level3_count[i*2] + level3_count[i*2+1];
    end

    // Level 5: 16-bit counters (16 counters)
    reg [7:0] level5_count [0:15];
    for (i = 0; i < 16; i = i + 1) begin
        level5_count[i] = level4_count[i*2] + level4_count[i*2+1];
    end

    // Level 6: 32-bit counters (8 counters)
    reg [7:0] level6_count [0:7];
    for (i = 0; i < 8; i = i + 1) begin
        level6_count[i] = level5_count[i*2] + level5_count[i*2+1];
    end

    // Level 7: 64-bit counters (4 counters)
    reg [7:0] level7_count [0:3];
    for (i = 0; i < 4; i = i + 1) begin
        level7_count[i] = level6_count[i*2] + level6_count[i*2+1];
    end

    // Level 8: 128-bit counters (2 counters)
    reg [7:0] level8_count [0:1];
    for (i = 0; i < 2; i = i + 1) begin
        level8_count[i] = level7_count[i*2] + level7_count[i*2+1];
    end

    // Final count
    count = level8_count[0] + level8_count[1];

    out = count;
end

endmodule