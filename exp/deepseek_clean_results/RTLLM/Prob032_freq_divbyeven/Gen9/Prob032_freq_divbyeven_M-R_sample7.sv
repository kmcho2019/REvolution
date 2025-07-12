module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 4; // Must be even number (2, 4, 6, ...)

reg [3:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        clk_div <= 0;
    end else begin
        cnt <= (cnt == (NUM_DIV/2 - 1)) ? 0 : cnt + 1;
        clk_div <= (cnt == (NUM_DIV/2 - 1)) ? ~clk_div : clk_div;
    end
end

endmodule