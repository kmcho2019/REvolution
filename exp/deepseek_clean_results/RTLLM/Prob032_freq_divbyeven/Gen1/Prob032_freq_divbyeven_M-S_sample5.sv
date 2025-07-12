module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 4; // Even division factor
localparam HALF_DIV = NUM_DIV/2 - 1;

reg [3:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        clk_div <= 0;
    end
    else begin
        cnt <= (cnt == HALF_DIV) ? 0 : cnt + 1;
        if (cnt == HALF_DIV) clk_div <= ~clk_div;
    end
end

endmodule