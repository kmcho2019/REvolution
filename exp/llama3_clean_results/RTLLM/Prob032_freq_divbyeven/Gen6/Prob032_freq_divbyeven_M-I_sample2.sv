module freq_diveven(
    input clk,
    input rst_n,
    output reg clk_div
);

parameter NUM_DIV = 8; // Must be an even number

reg [3:0] cnt; // 4-bit counter to track input clock cycles
reg half_div; // Pre-calculate half of NUM_DIV - 1 for comparison

always @(*) begin
    half_div = (NUM_DIV / 2) - 1;
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 4'd0;
        clk_div <= 1'b0;
    end else if (cnt == half_div) begin
        cnt <= 4'd0;
        clk_div <= ~clk_div;
    end else begin
        cnt <= cnt + 1;
    end
end

endmodule