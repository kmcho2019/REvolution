module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// Segment size parameter for better optimization
parameter SEGMENT_SIZE = 25;
localparam NUM_SEGMENTS = 100/SEGMENT_SIZE;

// Segment rotation signals
wire [99:0] right_rot_segments [0:NUM_SEGMENTS-1];
wire [99:0] left_rot_segments [0:NUM_SEGMENTS-1];

// Generate segment rotation logic
genvar i;
generate
    for (i = 0; i < NUM_SEGMENTS; i = i + 1) begin : SEG_ROT
        // Right rotation segments
        assign right_rot_segments[i] = (i == 0) ? {q[0], q[99:1]} : right_rot_segments[i-1];
        
        // Left rotation segments
        assign left_rot_segments[i] = (i == 0) ? {q[98:0], q[99]} : left_rot_segments[i-1];
    end
endgenerate

always @(posedge clk) begin
    if (load) begin
        q <= data;  // Synchronous load has highest priority
    end else begin
        case (ena)
            2'b01: q <= right_rot_segments[NUM_SEGMENTS-1];  // Right rotate using segmented logic
            2'b10: q <= left_rot_segments[NUM_SEGMENTS-1];   // Left rotate using segmented logic
            default: q <= q;                                // No rotation - clock gating optimized
        endcase
    end
end

endmodule