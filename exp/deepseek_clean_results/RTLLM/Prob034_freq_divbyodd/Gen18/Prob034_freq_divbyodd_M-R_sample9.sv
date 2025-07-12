module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number >=3
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Parameter validation
initial begin
    if (NUM_DIV < 3 || NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number >= 3");
        $finish;
    end
end

localparam CNT_WIDTH = $clog2(NUM_DIV);
localparam HALF_DIV = (NUM_DIV - 1)/2;

// Positive edge domain
reg [CNT_WIDTH-1:0] pos_cnt;
wire pos_toggle = (pos_cnt == HALF_DIV);
wire clk_pos;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pos_cnt <= 0;
    end else begin
        pos_cnt <= (pos_cnt == NUM_DIV - 1) ? 0 : pos_cnt + 1;
    end
end

assign clk_pos = (pos_cnt > HALF_DIV) ? 1'b1 : 1'b0;

// Negative edge domain
reg [CNT_WIDTH-1:0] neg_cnt;
wire neg_toggle = (neg_cnt == HALF_DIV);
wire clk_neg;

always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        neg_cnt <= 0;
    end else begin
        neg_cnt <= (neg_cnt == NUM_DIV - 1) ? 0 : neg_cnt + 1;
    end
end

assign clk_neg = (neg_cnt > HALF_DIV) ? 1'b1 : 1'b0;

// Combined output
assign clk_div = clk_pos | clk_neg;

endmodule