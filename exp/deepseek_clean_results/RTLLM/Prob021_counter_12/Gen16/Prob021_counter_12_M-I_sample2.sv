module counter_12 (
    input wire rst_n,
    input wire clk,
    input wire valid_count,
    output reg [3:0] out
);

always @(posedge clk) begin
    if (!rst_n) begin
        out <= 4'b0;
    end
    else if (valid_count) begin
        out <= out + 1'b1;
    end
end

endmodule