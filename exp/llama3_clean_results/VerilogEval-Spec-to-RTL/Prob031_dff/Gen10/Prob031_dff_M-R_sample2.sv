module TopModule(
    input clk,
    input d,
    input rst_n, // Active low reset
    input clk_en, // Clock enable
    output reg q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        q <= 0; // Reset q to 0 on active low reset
    end else if (clk_en) begin
        q <= d; // Update q only when clock enable is high
    end
end

endmodule