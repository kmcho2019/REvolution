module TopModule (
    input  [254:0] in,
    output [7:0] out
);

// Divide the input into 17 segments of 15 bits
reg [14:0] segment [16:0];

// Population count for each segment using a compressor tree
reg [7:0] segment_count [16:0];

always @(*) begin
    // Initialize counts
    for (int i = 0; i < 17; i++) begin
        segment_count[i] = 8'd0;
    end
    
    // Divide the input into segments
    for (int i = 0; i < 17; i++) begin
        if (i < 17) begin
            if (i == 16) begin
                segment[i] = in[(i*15)+:15];
                segment[i][14] = 1'b0;
                segment[i][13] = 1'b0;
                segment[i][12] = 1'b0;
            end else begin
                segment[i] = in[(i*15)+:15];
            end
        end
    end
    
    // Population count for each segment using a compressor tree
    for (int i = 0; i < 17; i++) begin
        reg [7:0] count;
        count = 8'd0;
        for (int j = 0; j < 15; j++) begin
            if (segment[i][j]) begin
                count = count + 1;
            end
        end
        segment_count[i] = count;
    end
    
    // Ripple carry adder to sum up the counts from each segment
    reg [7:0] sum;
    sum = 8'd0;
    for (int i = 0; i < 17; i++) begin
        sum = sum + segment_count[i];
    end
    
    out = sum;
end

endmodule