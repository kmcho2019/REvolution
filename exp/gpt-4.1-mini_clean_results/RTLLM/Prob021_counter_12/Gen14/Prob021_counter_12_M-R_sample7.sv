module counter_12 (
    input wire rst_n,
    input wire clk,
    input wire valid_count,
    output reg [3:0] out
);

wire [3:0] next_count;

assign next_count = (out == 4'd11) ? 4'b0000 : (out + 1);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        out <= 4'b0000;
    else if (valid_count)
        out <= next_count;
    else
        out <= out;  // Hold current value when valid_count is low
end

endmodule