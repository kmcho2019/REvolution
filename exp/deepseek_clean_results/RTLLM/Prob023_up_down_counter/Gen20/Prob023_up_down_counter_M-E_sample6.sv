module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Variable segment sizing: [15:11], [10:7], [6:3], [2:0]
wire [4:0] seg3 = count[15:11];  // 5-bit segment
wire [3:0] seg2 = count[10:7];   // 4-bit segment
wire [3:0] seg1 = count[6:3];    // 4-bit segment
wire [2:0] seg0 = count[2:0];    // 3-bit segment

// Direction-aware boundary detection
wire seg0_bound = up_down ? &seg0 : ~|seg0;
wire seg1_bound = up_down ? &seg1 : ~|seg1;
wire seg2_bound = up_down ? &seg2 : ~|seg2;

// Predictive carry generation
wire carry0 = seg0_bound;
wire carry1 = seg0_bound & seg1_bound;
wire carry2 = seg0_bound & seg1_bound & seg2_bound;

// Segment enable signals (clock gating)
wire seg0_en = 1'b1;  // Always enabled (LSB segment)
wire seg1_en = carry0 || (up_down ? |seg1 : ~&seg1);
wire seg2_en = carry1 || (up_down ? |seg2 : ~&seg2);
wire seg3_en = carry2 || (up_down ? |seg3 : ~&seg3);

// Next segment values with conditional updates
wire [2:0] next_seg0 = seg0_en ? (up_down ? seg0 + 1'b1 : seg0 - 1'b1) : seg0;
wire [3:0] next_seg1 = seg1_en ? (up_down ? seg1 + carry0 : seg1 - carry0) : seg1;
wire [3:0] next_seg2 = seg2_en ? (up_down ? seg2 + carry1 : seg2 - carry1) : seg2;
wire [4:0] next_seg3 = seg3_en ? (up_down ? seg3 + carry2 : seg3 - carry2) : seg3;

always @(posedge clk) begin
    if (reset) begin
        count <= 16'h0000;
    end else begin
        count <= {next_seg3, next_seg2, next_seg1, next_seg0};
    end
end

endmodule