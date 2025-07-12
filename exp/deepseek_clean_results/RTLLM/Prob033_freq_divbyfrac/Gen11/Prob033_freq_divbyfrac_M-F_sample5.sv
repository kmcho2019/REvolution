module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] pos_cnt;
reg [2:0] neg_cnt;
wire clk_a;
wire clk_b;

// Positive edge counter (0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pos_cnt <= 3'b0;
    end else begin
        pos_cnt <= (pos_cnt == 3'd6) ? 3'b0 : pos_cnt + 1;
    end
end

// Negative edge counter (0-6)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        neg_cnt <= 3'b0;
    end else begin
        neg_cnt <= (neg_cnt == 3'd6) ? 3'b0 : neg_cnt + 1;
    end
end

// Clock generation (4 cycles high, 3 cycles low)
assign clk_a = (pos_cnt < 3'd4) ? 1'b1 : 1'b0;
assign clk_b = (neg_cnt < 3'd4) ? 1'b1 : 1'b0;

// Combined output for fractional division
assign clk_div = clk_a | clk_b;

endmodule