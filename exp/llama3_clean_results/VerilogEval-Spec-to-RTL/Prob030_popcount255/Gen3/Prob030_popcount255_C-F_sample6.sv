module TopModule (
    input  [254:0] in,
    output [7:0] out
);

reg [7:0] count;

// Divide the input into 16 chunks of 16 bits
reg [15:0] chunk [15:0];

// Population count for each chunk
reg [4:0] chunk_count [15:0];

// Tree-like adder structure
reg [4:0] level1_sum [7:0];
reg [5:0] level2_sum [3:0];
reg [6:0] level3_sum [1:0];
reg [7:0] final_sum;

always @(*) begin
    // Initialize counts
    for (int i = 0; i < 16; i++) begin
        chunk_count[i] = 5'd0;
    end
    
    // Divide the input into chunks
    for (int i = 0; i < 16; i++) begin
        chunk[i] = in[(i*16)+:16];
    end
    
    // Population count for each chunk
    for (int i = 0; i < 16; i++) begin
        for (int j = 0; j < 16; j++) begin
            if (chunk[i][j]) begin
                chunk_count[i] = chunk_count[i] + 1;
            end
        end
    end
    
    // Tree-like adder structure
    for (int i = 0; i < 8; i++) begin
        level1_sum[i] = chunk_count[i*2] + chunk_count[i*2+1];
    end
    
    for (int i = 0; i < 4; i++) begin
        level2_sum[i] = level1_sum[i*2] + level1_sum[i*2+1];
    end
    
    for (int i = 0; i < 2; i++) begin
        level3_sum[i] = level2_sum[i*2] + level2_sum[i*2+1];
    end
    
    final_sum = level3_sum[0] + level3_sum[1];
    
    count = final_sum[7:0];
end

assign out = count;

endmodule