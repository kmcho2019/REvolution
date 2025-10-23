module counter_12 (
    input wire rst_n,
    input wire clk,
    input wire valid_count,
    output reg [3:0] out
);

parameter MAX_COUNT = 4'd11;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end
    else if (valid_count) begin
        out <= (out == MAX_COUNT) ? 4'b0000 : out + 1'b1;
    end
    // else: out remains unchanged (implicit)
end

endmodule