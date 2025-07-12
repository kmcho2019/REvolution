module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 4; // Must be even number (2, 4, 6, ...)

reg [3:0] cnt;
wire cnt_limit = (cnt == (NUM_DIV/2 - 1));
wire cnt_reset = !rst_n || cnt_limit;

always @(posedge clk) begin
    if (!rst_n) begin
        cnt <= 0;
    end else if (cnt_limit) begin
        cnt <= 0;
    end else begin
        cnt <= cnt + 1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div <= 0;
    end else if (cnt_limit) begin
        clk_div <= ~clk_div;
    end
end

endmodule