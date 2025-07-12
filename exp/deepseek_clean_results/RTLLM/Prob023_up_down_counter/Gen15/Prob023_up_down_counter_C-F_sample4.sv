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

// Next value and carry computation
reg [3:0] next_seg0, next_seg1, next_seg2, next_seg3;
wire carry0, carry1, carry2;

// Segment 0: Simple increment/decrement with carry out
assign {carry0, next_seg0} = up_down ? (seg0 + 1'b1) : (seg0 - 1'b1);

// Segment 1: Update only if segment 0 carries
assign {carry1, next_seg1} = carry0 ? 
    (up_down ? (seg1 + 1'b1) : (seg1 - 1'b1)) : 
    {1'b0, seg1};

// Segment 2: Update only if segment 1 carries
assign {carry2, next_seg2} = carry1 ? 
    (up_down ? (seg2 + 1'b1) : (seg2 - 1'b1)) : 
    {1'b0, seg2};

// Segment 3: Update only if segment 2 carries
assign next_seg3 = carry2 ? 
    (up_down ? (seg3 + 1'b1) : (seg3 - 1'b1)) : 
    seg3;

always @(posedge clk) begin
    if (reset) begin
        count <= 16'h0000;
    end else begin
        count <= {next_seg3, next_seg2, next_seg1, next_seg0};
    end
end

endmodule