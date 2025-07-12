module TopModule(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] q_reg;

// Segment size for the ring buffer
localparam SEGMENT_SIZE = 10;

// Number of segments in the ring buffer
localparam NUM_SEGMENTS = 100 / SEGMENT_SIZE;

// Registers to store the segments
reg [SEGMENT_SIZE-1:0] segments [NUM_SEGMENTS-1:0];

// Multiplexers to select the correct input for each segment
always @(posedge clk) begin
    if (load) begin
        for (int i = 0; i < NUM_SEGMENTS; i++) begin
            segments[i] <= data[(i*SEGMENT_SIZE)+:SEGMENT_SIZE];
        end
    end else begin
        case (ena)
            2'b01: // Rotate right by one bit
                segments[0] <= {segments[NUM_SEGMENTS-1][SEGMENT_SIZE-1], segments[0][SEGMENT_SIZE-2:0]};
                for (int i = 1; i < NUM_SEGMENTS; i++) begin
                    segments[i] <= {segments[i-1][SEGMENT_SIZE-1], segments[i][SEGMENT_SIZE-2:0]};
                end
            2'b10: // Rotate left by one bit
                segments[NUM_SEGMENTS-1] <= {segments[NUM_SEGMENTS-1][SEGMENT_SIZE-2:0], segments[0][SEGMENT_SIZE-1]};
                for (int i = NUM_SEGMENTS-2; i >= 0; i--) begin
                    segments[i] <= {segments[i+1][SEGMENT_SIZE-1], segments[i][SEGMENT_SIZE-2:0]};
                end
            default: // No rotation
                for (int i = 0; i < NUM_SEGMENTS; i++) begin
                    segments[i] <= segments[i];
                end
        endcase
    end
end

// Assign the output
assign q = {>>{segments}};
endmodule