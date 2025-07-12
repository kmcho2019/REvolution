module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Next value computation using optimized continuous assignments
wire [3:0] next_seg0 = up_down ? count[3:0] + 1'b1 : count[3:0] - 1'b1;
wire seg0_wrap = up_down ? &count[3:0] : ~|count[3:0];

wire [3:0] next_seg1 = seg0_wrap ? 
                      (up_down ? count[7:4] + 1'b1 : count[7:4] - 1'b1) : 
                      count[7:4];
wire seg1_wrap = seg0_wrap && (up_down ? &count[7:4] : ~|count[7:4]);

wire [3:0] next_seg2 = seg1_wrap ? 
                      (up_down ? count[11:8] + 1'b1 : count[11:8] - 1'b1) : 
                      count[11:8];
wire seg2_wrap = seg1_wrap && (up_down ? &count[11:8] : ~|count[11:8]);

wire [3:0] next_seg3 = seg2_wrap ? 
                      (up_down ? count[15:12] + 1'b1 : count[15:12] - 1'b1) : 
                      count[15:12];

always @(posedge clk) begin
    if (reset) begin
        count <= 16'h0000;
    end else begin
        count <= {next_seg3, next_seg2, next_seg1, next_seg0};
    end
end

endmodule