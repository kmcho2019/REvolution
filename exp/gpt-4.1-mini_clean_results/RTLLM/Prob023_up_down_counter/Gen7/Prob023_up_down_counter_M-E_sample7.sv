module up_down_counter (
    input wire clk,
    input wire reset,
    input wire up_down,
    output reg [15:0] count
);

wire [15:0] increment = 16'd1;
wire [15:0] decrement = 16'd1;
wire [15:0] delta = up_down ? increment : decrement;
wire [15:0] next_count = up_down ? (count + increment) : (count - decrement);

always @(posedge clk) begin
    if (reset) begin
        count <= 16'd0;
    end else begin
        count <= next_count;
    end
end

endmodule