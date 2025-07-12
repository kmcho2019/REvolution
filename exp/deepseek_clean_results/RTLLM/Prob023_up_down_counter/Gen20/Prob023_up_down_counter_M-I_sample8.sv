module up_down_counter #(
    parameter WIDTH = 16,
    parameter SEGMENT = 4
) (
    input clk,
    input reset,
    input up_down,
    output reg [WIDTH-1:0] count
);

localparam NUM_SEGMENTS = WIDTH/SEGMENT;

// Packed array for segments
wire [SEGMENT-1:0] segments [NUM_SEGMENTS-1:0];
generate
    genvar i;
    for (i = 0; i < NUM_SEGMENTS; i = i + 1) begin
        assign segments[i] = count[i*SEGMENT +: SEGMENT];
    end
endgenerate

// Carry lookahead with conditional computation
wire [NUM_SEGMENTS-1:0] carry;
wire [SEGMENT-1:0] next_segments [NUM_SEGMENTS-1:0];

// First segment (LSB) always computes
assign next_segments[0] = up_down ? segments[0] + 1'b1 : segments[0] - 1'b1;
assign carry[0] = up_down ? &segments[0] : ~|segments[0];

// Hybrid carry-select for higher segments
generate
    for (i = 1; i < NUM_SEGMENTS; i = i + 1) begin : SEG_LOGIC
        // Conditional computation - only calculate when needed
        wire [SEGMENT-1:0] seg_inc = segments[i] + 1'b1;
        wire [SEGMENT-1:0] seg_dec = segments[i] - 1'b1;
        
        // Mux with clock gating enable
        wire seg_enable = carry[i-1];
        assign next_segments[i] = seg_enable ? 
                                 (up_down ? seg_inc : seg_dec) : 
                                 segments[i];
        assign carry[i] = seg_enable && 
                         (up_down ? &segments[i] : ~|segments[i]);
    end
endgenerate

// Combine next values
wire [WIDTH-1:0] next_count;
generate
    for (i = 0; i < NUM_SEGMENTS; i = i + 1) begin
        assign next_count[i*SEGMENT +: SEGMENT] = next_segments[i];
    end
endgenerate

always @(posedge clk) begin
    if (reset) begin
        count <= {WIDTH{1'b0}};
    end else begin
        count <= next_count;
    end
end

endmodule