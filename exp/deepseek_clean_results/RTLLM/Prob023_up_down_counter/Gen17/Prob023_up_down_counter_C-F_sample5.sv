module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Segment the counter into 4 nibbles
wire [3:0] seg0 = count[3:0];
wire [3:0] seg1 = count[7:4];
wire [3:0] seg2 = count[11:8];
wire [3:0] seg3 = count[15:12];

// Boundary conditions for each segment
wire seg0_bound = up_down ? (seg0 == 4'hF) : (seg0 == 4'h0);
wire seg1_bound = up_down ? (seg1 == 4'hF) : (seg1 == 4'h0);
wire seg2_bound = up_down ? (seg2 == 4'hF) : (seg2 == 4'h0);

// Hierarchical carry look-ahead
wire carry0 = seg0_bound;
wire carry1 = seg0_bound & seg1_bound;
wire carry2 = seg0_bound & seg1_bound & seg2_bound;

// Next segment values with conditional updates
wire [3:0] next_seg0 = up_down ? seg0 + 1'b1 : seg0 - 1'b1;
wire [3:0] next_seg1 = carry0 ? (up_down ? seg1 + 1'b1 : seg1 - 1'b1) : seg1;
wire [3:0] next_seg2 = carry1 ? (up_down ? seg2 + 1'b1 : seg2 - 1'b1) : seg2;
wire [3:0] next_seg3 = carry2 ? (up_down ? seg3 + 1'b1 : seg3 - 1'b1) : seg3;

// Combined next value
wire [15:0] next_count = {next_seg3, next_seg2, next_seg1, next_seg0};

always @(posedge clk) begin
    if (reset) begin
        count <= 16'h0000;
    end else begin
        count <= next_count;
    end
end

endmodule