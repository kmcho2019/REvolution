module TopModule (
    input  [254:0] in,
    output [7:0] out
);

// Define a lookup table for population count
reg [1:0] lut_out [15:0];

// Initialize the lookup table
initial begin
    lut_out[0] = 2'd0; // 0000
    lut_out[1] = 2'd1; // 0001
    lut_out[2] = 2'd1; // 0010
    lut_out[3] = 2'd2; // 0011
    lut_out[4] = 2'd1; // 0100
    lut_out[5] = 2'd2; // 0101
    lut_out[6] = 2'd2; // 0110
    lut_out[7] = 2'd3; // 0111
    lut_out[8] = 2'd1; // 1000
    lut_out[9] = 2'd2; // 1001
    lut_out[10] = 2'd2; // 1010
    lut_out[11] = 2'd3; // 1011
    lut_out[12] = 2'd2; // 1100
    lut_out[13] = 2'd3; // 1101
    lut_out[14] = 2'd3; // 1110
    lut_out[15] = 2'd4; // 1111
end

// Divide the input into 64 segments of 4 bits
reg [3:0] segment [63:0];

always @(*) begin
    // Initialize segments
    for (int i = 0; i < 64; i++) begin
        segment[i] = in[(i*4)+:4];
    end
end

// Population count for each segment
reg [1:0] segment_count [63:0];

always @(*) begin
    // Initialize counts
    for (int i = 0; i < 64; i++) begin
        segment_count[i] = lut_out[segment[i]];
    end
end

// Wallace tree adder to sum up the counts from each segment
reg [7:0] count;

always @(*) begin
    // Initialize count
    count = 8'd0;
    
    // Add up the counts from each segment
    for (int i = 0; i < 64; i++) begin
        count = count + segment_count[i];
    end
end

assign out = count;

endmodule