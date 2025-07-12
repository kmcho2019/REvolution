module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Parameters for segmentation
    localparam SEGMENTS = 4;
    localparam SEG_WIDTH = 128;

    // Segment update index (0 to 3)
    reg [1:0] seg_index;

    // Buffer for next state partial segments
    reg [SEG_WIDTH-1:0] next_segment;

    // Temporary wires for left, center, right neighbors of segment cells
    wire [SEG_WIDTH+1:0] ext_segment;  // zero padded segment window of length 130 (128 + 2 neighbors)
    
    // Current segment extraction with one-bit padding on both sides
    wire [SEG_WIDTH-1:0] current_segment = q[seg_index*SEG_WIDTH +: SEG_WIDTH];
    
    // Neighbors for boundary handling across segments
    wire left_neighbor_bit = (seg_index == 0) ? 1'b0 : q[(seg_index*SEG_WIDTH)-1];
    wire right_neighbor_bit = (seg_index == SEGMENTS-1) ? 1'b0 : q[(seg_index+1)*SEG_WIDTH];

    // Build extended segment vector with zero padding on both ends
    assign ext_segment = {left_neighbor_bit, current_segment, right_neighbor_bit};

    // Rule 110 combinational function inline (for efficiency)
    // next = (~left & center) | (center ^ right)
    genvar i;
    generate
        for (i=0; i < SEG_WIDTH; i=i+1) begin : RULE110_SEGMENT
            wire left   = ext_segment[i+2];
            wire center = ext_segment[i+1];
            wire right  = ext_segment[i];
            wire next_bit = (~left & center) | (center ^ right);
            always @(*) begin
                next_segment[i] = next_bit;
            end
        end
    endgenerate

    always @(posedge clk) begin
        if (load) begin
            q <= data;
            seg_index <= 0;
        end else begin
            // Update only the segment selected by seg_index with next_segment result
            q[seg_index*SEG_WIDTH +: SEG_WIDTH] <= next_segment;

            // Advance segment index modulo SEGMENTS
            seg_index <= seg_index + 1;
        end
    end

endmodule