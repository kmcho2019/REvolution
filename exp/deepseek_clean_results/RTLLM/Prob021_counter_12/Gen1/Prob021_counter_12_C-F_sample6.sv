module counter_12 (
    input wire rst_n,
    input wire clk,
    input wire valid_count,
    output reg [3:0] out
);

wire count_enable = valid_count;
wire wrap_around = (out == 4'd11) & count_enable;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end
    else if (wrap_around) begin
        out <= 4'b0000;
    end
    else if (count_enable) begin
        out <= out + 1'b1;
    end
    // else maintain value (implicit)
end

endmodule