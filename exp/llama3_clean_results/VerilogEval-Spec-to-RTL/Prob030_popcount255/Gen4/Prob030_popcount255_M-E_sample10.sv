module TopModule (
    input  [254:0] in,
    output [7:0] out
);

// Define a lookup table for population counts of 8-bit values
reg [7:0] lut [255:0];

// Initialize the lookup table
initial begin
    for (int i = 0; i < 256; i++) begin
        lut[i] = 8'd0;
        for (int j = 0; j < 8; j++) begin
            if (i & (1 << j)) begin
                lut[i] = lut[i] + 1;
            end
        end
    end
end

// Divide the input into 32 segments of 8 bits
reg [7:0] segment [31:0];

// Population counts for each segment
reg [7:0] segment_count [31:0];

// Final population count
reg [7:0] count;

always @(*) begin
    // Divide the input into segments
    for (int i = 0; i < 32; i++) begin
        if (i < 31) begin
            segment[i] = in[(i*8)+:8];
        end else begin
            segment[i] = {1'b0, in[(i*8)+:7]};
        end
    end
    
    // Population counts for each segment
    for (int i = 0; i < 32; i++) begin
        segment_count[i] = lut[segment[i]];
    end
    
    // Tree-like structure of adders to sum up the population counts
    count = 8'd0;
    for (int i = 0; i < 32; i++) begin
        count = count + segment_count[i];
    end
end

assign out = count;

endmodule