module up_down_counter (
    input wire clk,
    input wire reset,
    input wire up_down,
    output reg [15:0] count
);

wire [15:0] inc_count = count + 16'd1;
wire [15:0] dec_count = count - 16'd1;

always @(posedge clk) begin
    if (reset)
        count <= 16'd0;
    else
        count <= up_down ? inc_count : dec_count;
end

endmodule