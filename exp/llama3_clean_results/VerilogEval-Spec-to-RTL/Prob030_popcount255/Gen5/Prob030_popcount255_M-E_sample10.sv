module TopModule (
    input  [254:0] in,
    output [7:0] out
);

// Divide the input into 32 chunks of 8 bits
reg [7:0] chunk [31:0];

// Pre-computed table for population count of 8-bit numbers
reg [3:0] pop_count_table [255:0];

// Initialize the pre-computed table
always @(*) begin
    for (int i = 0; i < 256; i++) begin
        pop_count_table[i] = 4'd0;
        for (int j = 0; j < 8; j++) begin
            if (i[j]) begin
                pop_count_table[i] = pop_count_table[i] + 1;
            end
        end
    end
end

// Divide the input into chunks
always @(*) begin
    for (int i = 0; i < 32; i++) begin
        if (i < 31) begin
            chunk[i] = in[(i*8)+:8];
        end else begin
            chunk[i] = {1'b0, in[(i*8)+:7]};
        end
    end
end

// Hierarchical adder tree
reg [7:0] level1_sum [15:0];
reg [7:0] level2_sum [7:0];
reg [7:0] level3_sum [3:0];
reg [7:0] level4_sum [1:0];

always @(*) begin
    // Level 1: Calculate the sum of each pair of chunks
    for (int i = 0; i < 16; i++) begin
        level1_sum[i] = pop_count_table[chunk[i*2]] + pop_count_table[chunk[i*2+1]];
    end
    
    // Level 2: Calculate the sum of each pair of level 1 sums
    for (int i = 0; i < 8; i++) begin
        level2_sum[i] = level1_sum[i*2] + level1_sum[i*2+1];
    end
    
    // Level 3: Calculate the sum of each pair of level 2 sums
    for (int i = 0; i < 4; i++) begin
        level3_sum[i] = level2_sum[i*2] + level2_sum[i*2+1];
    end
    
    // Level 4: Calculate the final sum
    level4_sum[0] = level3_sum[0] + level3_sum[1];
    level4_sum[1] = level3_sum[2] + level3_sum[3];
end

assign out = level4_sum[0] + level4_sum[1];

endmodule