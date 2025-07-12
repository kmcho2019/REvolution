module up_down_counter (
    input clk,
    input reset,
    input up_down,
    input enable,
    output reg [15:0] count,
    output reg overflow,
    output reg underflow
);

// Segment the counter into 4 4-bit counters with registered outputs
reg [3:0] count_seg0, count_seg1, count_seg2, count_seg3;
wire [3:0] next_seg0, next_seg1, next_seg2, next_seg3;
wire carry0, carry1, carry2;

// Clock gating control
wire seg0_active = enable && (|count[15:4] || up_down || ~up_down);
wire seg1_active = enable && (|count[15:8] || up_down || ~up_down);
wire seg2_active = enable && (|count[15:12] || up_down || ~up_down);
wire seg3_active = enable;

// Segment 0 (LSB) counter
assign next_seg0 = up_down ? count_seg0 + 1'b1 : count_seg0 - 1'b1;
assign carry0 = up_down ? &count_seg0 : ~|count_seg0;

// Segment 1 counter
assign next_seg1 = up_down ? count_seg1 + carry0 : count_seg1 - carry0;
assign carry1 = up_down ? (&count_seg1 & carry0) : (~|count_seg1 & carry0);

// Segment 2 counter
assign next_seg2 = up_down ? count_seg2 + carry1 : count_seg2 - carry1;
assign carry2 = up_down ? (&count_seg2 & carry1) : (~|count_seg2 & carry1);

// Segment 3 (MSB) counter
assign next_seg3 = up_down ? count_seg3 + carry2 : count_seg3 - carry2;

always @(posedge clk) begin
    if (reset) begin
        {count_seg3, count_seg2, count_seg1, count_seg0} <= 16'b0;
        overflow <= 1'b0;
        underflow <= 1'b0;
    end else if (enable) begin
        // Update segments with clock gating
        if (seg0_active) count_seg0 <= next_seg0;
        if (seg1_active) count_seg1 <= next_seg1;
        if (seg2_active) count_seg2 <= next_seg2;
        if (seg3_active) count_seg3 <= next_seg3;
        
        // Detect overflow/underflow
        overflow <= up_down && &count && carry0;
        underflow <= ~up_down && ~|count && carry0;
    end
end

// Combine segments
always @(*) begin
    count = {count_seg3, count_seg2, count_seg1, count_seg0};
end

endmodule