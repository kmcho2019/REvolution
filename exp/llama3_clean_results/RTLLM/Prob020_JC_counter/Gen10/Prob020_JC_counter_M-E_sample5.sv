// Module JC_counter: 64-bit Johnson counter
module JC_counter(
    input clk, // Clock signal
    input rst_n, // Active-low reset signal
    output reg [63:0] Q // 64-bit register representing the current count value
);

// Define the segment size
localparam SEGMENT_SIZE = 8;

// Calculate the number of segments
localparam NUM_SEGMENTS = 64 / SEGMENT_SIZE;

// Internal signals
reg [SEGMENT_SIZE-1:0] segments [NUM_SEGMENTS-1:0];

// Always block: synchronous operation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter to 0
        for (int i = 0; i < NUM_SEGMENTS; i++) begin
            segments[i] <= {SEGMENT_SIZE{1'b0}};
        end
    end else begin
        // Normal operation
        if (Q[0] == 1'b0) begin
            // Shift right and append 1
            segments[0] <= {1'b1, segments[NUM_SEGMENTS-1][SEGMENT_SIZE-1:1]};
            for (int i = 1; i < NUM_SEGMENTS; i++) begin
                segments[i] <= {segments[i-1][SEGMENT_SIZE-1], segments[i][SEGMENT_SIZE-1:1]};
            end
        end else begin
            // Shift right and append 0
            segments[0] <= {1'b0, segments[NUM_SEGMENTS-1][SEGMENT_SIZE-1:1]};
            for (int i = 1; i < NUM_SEGMENTS; i++) begin
                segments[i] <= {segments[i-1][SEGMENT_SIZE-1], segments[i][SEGMENT_SIZE-1:1]};
            end
        end
    end
end

// Assign the output
always @(*) begin
    Q = {segments[NUM_SEGMENTS-1], segments[NUM_SEGMENTS-2], segments[NUM_SEGMENTS-3], segments[NUM_SEGMENTS-4], 
         segments[NUM_SEGMENTS-5], segments[NUM_SEGMENTS-6], segments[NUM_SEGMENTS-7], segments[0]};
end

endmodule