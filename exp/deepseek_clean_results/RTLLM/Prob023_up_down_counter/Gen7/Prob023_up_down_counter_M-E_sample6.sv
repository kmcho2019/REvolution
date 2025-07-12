module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

wire [15:0] next_count_up = count + 1;
wire [15:0] next_count_down = count - 1;

always @(posedge clk) begin
    if (reset)
        count <= 0;
    else
        count <= up_down ? next_count_up : next_count_down;
end

endmodule