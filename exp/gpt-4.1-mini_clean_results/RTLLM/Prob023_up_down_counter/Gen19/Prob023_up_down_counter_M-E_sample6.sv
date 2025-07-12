module up_down_counter (
    input  wire         clk,
    input  wire         reset,
    input  wire         up_down,
    output reg [15:0]   count
);

wire [15:0] incremented = count + 16'd1;
wire [15:0] decremented = count - 16'd1;
wire [15:0] next_count = up_down ? incremented : decremented;

always @(posedge clk) begin
    if (reset) begin
        count <= 16'd0;
    end else begin
        count <= next_count;
    end
end

endmodule