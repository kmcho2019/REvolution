module TopModule (
    input  [254:0] in,
    output [7:0] out
);

reg [7:0] count;

// Population count for each segment
reg [7:0] segment_count [31:0];

always @(*) begin
    // Initialize counts
    count = 8'd0;
    
    // Population count for each segment
    for (int i = 0; i < 8; i++) begin
        segment_count[i] = 8'd0;
        for (int j = 0; j < 32; j++) begin
            if (i < 8 && j < 32) begin
                if (in[(i*32)+j]) begin
                    segment_count[i] = segment_count[i] + 1;
                end
            end
        end
    end
    
    for (int i = 0; i < 8; i++) begin
        count = count + segment_count[i];
    end
    
    // Calculate population count for the last 7 bits
    reg [7:0] last_segment_count;
    last_segment_count = 8'd0;
    for (int i = 0; i < 7; i++) begin
        if (in[(8*32)+i]) begin
            last_segment_count = last_segment_count + 1;
        end
    end
    
    // Add the count from the last segment
    count = count + last_segment_count;
end

assign out = count;

endmodule