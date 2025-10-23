module freq_diveven (
    input clk,
    input rst_n,
    output reg clk_div
);

parameter NUM_DIV = 4;
reg [3:0] cnt;

always @(posedge clk) begin
    if (!rst_n) begin
        cnt <= 0;
        clk_div <= 0;
    end
    else if (cnt == NUM_DIV/2 - 1) begin
        cnt <= 0;
        clk_div <= ~clk_div;
    end
    else begin
        cnt <= cnt + 1;
    end
end

endmodule