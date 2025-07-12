module TopModule(
    input [254:0] in,
    output [7:0] out
);

parameter INPUT_WIDTH = 255;
parameter OUTPUT_WIDTH = 8;
parameter SEGMENT_WIDTH = 8;

// Calculate the number of segments
parameter NUM_SEGMENTS = (INPUT_WIDTH + SEGMENT_WIDTH - 1) / SEGMENT_WIDTH;

// Define the segments
wire [SEGMENT_WIDTH-1:0] segments [NUM_SEGMENTS-1:0];

// Assign the segments
genvar i;
generate
    for (i = 0; i < NUM_SEGMENTS; i = i + 1) begin
        assign segments[i] = in[(i+1)*SEGMENT_WIDTH-1 : i*SEGMENT_WIDTH];
    end
endgenerate

// Define the population counts for each segment
wire [OUTPUT_WIDTH-1:0] segment_counts [NUM_SEGMENTS-1:0];

// Assign the population counts
genvar j;
generate
    for (j = 0; j < NUM_SEGMENTS; j = j + 1) begin
        assign segment_counts[j] = $countones(segments[j]);
    end
endgenerate

// Define the final population count
wire [OUTPUT_WIDTH-1:0] count;

// Assign the final population count using a carry-save adder tree structure
wire [OUTPUT_WIDTH-1:0] carry [NUM_SEGMENTS-1:0];
wire [OUTPUT_WIDTH-1:0] sum [NUM_SEGMENTS-1:0];

assign carry[0] = 0;
assign sum[0] = segment_counts[0];

genvar k;
generate
    for (k = 1; k < NUM_SEGMENTS; k = k + 1) begin
        assign carry[k] = sum[k-1][OUTPUT_WIDTH-1];
        assign sum[k] = sum[k-1][OUTPUT_WIDTH-2:0] + segment_counts[k];
    end
endgenerate

assign count = sum[NUM_SEGMENTS-1];

// Assign the output
assign out = count;

endmodule