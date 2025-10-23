module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Next value computation using optimized 5-bit arithmetic for carry
wire [4:0] seg0_next = up_down ? {1'b0, count[3:0]} + 5'd1 : {1'b0, count[3:0]} - 5'd1;
wire carry0 = seg0_next[4];

wire [4:0] seg1_next = carry0 ? 
                      (up_down ? {1'b0, count[7:4]} + 5'd1 : {1'b0, count[7:4]} - 5'd1) : 
                      {1'b0, count[7:4]};
wire carry1 = seg1_next[4];

wire [4:0] seg2_next = carry1 ? 
                      (up_down ? {1'b0, count[11:8]} + 5'd1 : {1'b0, count[11:8]} - 5'd1) : 
                      {1'b0, count[11:8]};
wire carry2 = seg2_next[4];

wire [3:0] seg3_next = carry2 ? 
                      (up_down ? count[15:12] + 4'd1 : count[15:12] - 4'd1) : 
                      count[15:12];

always @(posedge clk) begin
    if (reset) begin
        count <= 16'h0000;
    end else begin
        count <= {seg3_next, seg2_next[3:0], seg1_next[3:0], seg0_next[3:0]};
    end
end

endmodule