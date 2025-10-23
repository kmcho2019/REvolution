module counter_12 (
    input wire rst_n,
    input wire clk,
    input wire valid_count,
    output reg [3:0] out
);

// Use a clock enable signal derived from valid_count
wire count_enable = valid_count;

always @(posedge clk) begin
    if (!rst_n)
        out <= 4'b0000;
    else if (count_enable) begin
        if (out == 4'd11)
            out <= 4'b0000;
        else
            out <= out + 1;
    end
end

endmodule