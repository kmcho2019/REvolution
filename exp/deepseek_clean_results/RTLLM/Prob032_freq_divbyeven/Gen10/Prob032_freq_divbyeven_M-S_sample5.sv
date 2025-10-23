module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 4; // Must be even number (2, 4, 6, ...)

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div <= 0;
    end else begin
        if (clk_div == 0) begin
            clk_div <= 1;
        end else begin
            clk_div <= 0;
        end
    end
end

endmodule