module TopModule (
    input  [254:0] in,
    output [7:0] out
);

reg [7:0] count;

// Divide the input into 16 chunks of 16 bits
reg [15:0] chunk [15:0];

// Prefix sum for each chunk
reg [4:0] chunk_sum [15:0];

always @(*) begin
    // Initialize sums
    for (int i = 0; i < 16; i++) begin
        chunk_sum[i] = 5'd0;
    end
    
    // Divide the input into chunks
    for (int i = 0; i < 16; i++) begin
        if (i < 15) begin
            chunk[i] = in[(i*16)+:16];
        end else begin
            chunk[i] = {9'b0, in[(i*16)+:7]};
        end
    end
    
    // Prefix sum for each chunk
    for (int i = 0; i < 16; i++) begin
        reg [4:0] temp_sum;
        temp_sum = 5'd0;
        for (int j = 0; j < 16; j++) begin
            if (chunk[i][j]) begin
                temp_sum = temp_sum + 1;
            end
        end
        chunk_sum[i] = temp_sum;
    end
    
    // Combine outputs from each chunk using prefix sum
    count = 8'd0;
    for (int i = 0; i < 16; i++) begin
        count = count + chunk_sum[i];
    end
end

assign out = count;

endmodule