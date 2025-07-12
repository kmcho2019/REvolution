module TopModule (
    input  [254:0] in,
    output [7:0] out
);

reg [7:0] count;

// Divide the input into 15 segments of 17 bits
reg [16:0] segment [14:0];

// Population count for each segment
reg [5:0] segment_count [14:0];

always @(*) begin
    // Initialize counts
    for (int i = 0; i < 15; i++) begin
        segment_count[i] = 6'd0;
    end
    
    // Divide the input into segments
    for (int i = 0; i < 15; i++) begin
        segment[i] = in[(i*17)+:17];
    end
    
    // Population count for each segment
    for (int i = 0; i < 15; i++) begin
        for (int j = 0; j < 17; j++) begin
            if (segment[i][j]) begin
                segment_count[i] = segment_count[i] + 1;
            end
        end
    end
    
    // Parallel adder to sum up the counts from each segment
    count = 8'd0;
    for (int i = 0; i < 15; i++) begin
        count = count + segment_count[i];
    end
end

assign out = count;

endmodule