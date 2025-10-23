module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output [15:0] count
);

reg [3:0] seg0, seg1, seg2, seg3;
wire seg0_max = &seg0;
wire seg0_min = ~|seg0;
wire seg1_max = &seg1;
wire seg1_min = ~|seg1;
wire seg2_max = &seg2;
wire seg2_min = ~|seg2;

wire seg0_roll = up_down ? seg0_max : seg0_min;
wire seg1_roll = up_down ? seg1_max : seg1_min;
wire seg2_roll = up_down ? seg2_max : seg2_min;

always @(posedge clk) begin
    if (reset) begin
        seg0 <= 4'b0;
        seg1 <= 4'b0;
        seg2 <= 4'b0;
        seg3 <= 4'b0;
    end else begin
        // Segment 0 always counts
        seg0 <= up_down ? seg0 + 1'b1 : seg0 - 1'b1;
        
        // Segment 1 counts when seg0 rolls over
        if (seg0_roll) begin
            seg1 <= up_down ? seg1 + 1'b1 : seg1 - 1'b1;
        end
        
        // Segment 2 counts when both seg0 and seg1 roll over
        if (seg0_roll && seg1_roll) begin
            seg2 <= up_down ? seg2 + 1'b1 : seg2 - 1'b1;
        end
        
        // Segment 3 counts when all lower segments roll over
        if (seg0_roll && seg1_roll && seg2_roll) begin
            seg3 <= up_down ? seg3 + 1'b1 : seg3 - 1'b1;
        end
    end
end

assign count = {seg3, seg2, seg1, seg0};

endmodule