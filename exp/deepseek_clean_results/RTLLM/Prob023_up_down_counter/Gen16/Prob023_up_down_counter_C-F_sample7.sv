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

// Next value computation with optimized carry logic
wire [3:0] next_seg0;
wire carry0;
assign {carry0, next_seg0} = up_down ? (seg0 + 1'b1) : {1'b1, seg0 - 1'b1};

wire [3:0] next_seg1;
wire carry1;
assign {carry1, next_seg1} = carry0 ? 
    (up_down ? (seg1 + 1'b1) : {1'b1, seg1 - 1'b1}) : 
    {1'b0, seg1};

wire [3:0] next_seg2;
wire carry2;
assign {carry2, next_seg2} = carry1 ? 
    (up_down ? (seg2 + 1'b1) : {1'b1, seg2 - 1'b1}) : 
    {1'b0, seg2};

wire [3:0] next_seg3 = carry2 ? 
    (up_down ? (seg3 + 1'b1) : (seg3 - 1'b1)) : 
    seg3;

// Combine next values
wire [15:0] next_count = {next_seg3, next_seg2, next_seg1, next_seg0};

always @(posedge clk) begin
    if (reset) begin
        count <= 16'h0000;
    end else begin
        count <= next_count;
    end
end

endmodule