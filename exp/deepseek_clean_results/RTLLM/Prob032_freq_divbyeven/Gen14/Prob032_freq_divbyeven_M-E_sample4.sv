module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 6;  // Must be even number
localparam CNT_WIDTH = $clog2(NUM_DIV);
localparam CNT_INIT = (NUM_DIV/2) - 1;

reg [CNT_WIDTH-1:0] cnt;
wire cnt_zero = (cnt == 0);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= CNT_INIT;
        clk_div <= 1'b0;
    end else begin
        if (cnt_zero) begin
            cnt <= CNT_INIT;
            clk_div <= ~clk_div;  // Toggle only when counter expires
        end else begin
            // XOR feedback for pseudo-random counting pattern
            cnt <= {1'b0, cnt[CNT_WIDTH-1:1]} ^ cnt[0];
        end
    end
end

endmodule