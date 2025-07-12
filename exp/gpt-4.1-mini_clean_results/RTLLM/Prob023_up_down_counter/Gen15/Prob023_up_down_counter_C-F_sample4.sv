module up_down_counter (
    input  wire        clk,
    input  wire        reset,
    input  wire        up_down,
    output reg [15:0]  count
);

wire [15:0] count_inc;
wire [15:0] count_dec;
reg  [15:0] next_count;

assign count_inc = count + 16'd1;
assign count_dec = count - 16'd1;

always @(*) begin
    if (up_down)
        next_count = count_inc;
    else
        next_count = count_dec;
end

always @(posedge clk) begin
    if (reset)
        count <= 16'd0;
    else
        count <= next_count;
end

endmodule