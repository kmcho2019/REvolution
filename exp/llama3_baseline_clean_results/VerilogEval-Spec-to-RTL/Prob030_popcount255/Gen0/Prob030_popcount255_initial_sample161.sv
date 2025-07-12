module TopModule(
    input [255:0] in,
    output [7:0] out
);

reg [7:0] out;

// Counting '1's in each byte and summing them up
reg [7:0] byte_counts [31:0];
reg [7:0] level1_sums [15:0];
reg [7:0] level2_sums [7:0];
reg [7:0] level3_sums [3:0];
reg [7:0] level4_sums [1:0];

// Count '1's in each byte
integer i;
always @(in) begin
    for (i = 0; i < 32; i++) begin
        byte_counts[i] = {8{1'b0}};
        for (int j = 0; j < 8; j++) begin
            if (in[(i * 8) + j]) begin
                byte_counts[i] = byte_counts[i] + 1;
            end
        end
    end

    // Sum up byte-level counts
    for (i = 0; i < 16; i++) begin
        level1_sums[i] = byte_counts[i * 2] + byte_counts[i * 2 + 1];
    end

    // Further sum up the level1_sums
    for (i = 0; i < 8; i++) begin
        level2_sums[i] = level1_sums[i * 2] + level1_sums[i * 2 + 1];
    end

    // Further sum up the level2_sums
    for (i = 0; i < 4; i++) begin
        level3_sums[i] = level2_sums[i * 2] + level2_sums[i * 2 + 1];
    end

    // Further sum up the level3_sums
    for (i = 0; i < 2; i++) begin
        level4_sums[i] = level3_sums[i * 2] + level3_sums[i * 2 + 1];
    end

    // Final sum
    out = level4_sums[0] + level4_sums[1];
end

endmodule