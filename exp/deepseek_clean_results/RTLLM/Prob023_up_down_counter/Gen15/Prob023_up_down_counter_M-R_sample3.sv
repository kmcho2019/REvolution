module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Next value computation using continuous assignments
wire [3:0] next_seg0 = up_down ? count[3:0] + 1'b1 : count[3:0] - 1'b1;
wire carry0 = up_down ? &count[3:0] : ~|count[3:0];

wire [3:0] next_seg1 = carry0 ? 
                      (up_down ? count[7:4] + 1'b1 : count[7:4] - 1'b1) : 
                      count[7:4];
wire carry1 = carry0 && (up_down ? &count[7:4] : ~|count[7:4]);

wire [3:0] next_seg2 = carry1 ? 
                      (up_down ? count[11:8] + 1'b1 : count[11:8] - 1'b1) : 
                      count[11:8];
wire carry2 = carry1 && (up_down ? &count[11:8] : ~|count[11:8]);

wire [3:0] next_seg3 = carry2 ? 
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