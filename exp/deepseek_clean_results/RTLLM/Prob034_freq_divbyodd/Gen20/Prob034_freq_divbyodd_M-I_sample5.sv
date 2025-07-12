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
reg clk_pos_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pos_cnt <= 0;
        clk_pos_reg <= 0;
    end else begin
        if (pos_cnt == NUM_DIV - 1) begin
            pos_cnt <= 0;
        end else begin
            pos_cnt <= pos_cnt + 1;
        end
        
        if (pos_cnt == HALF_DIV) begin
            clk_pos_reg <= ~clk_pos_reg;
        end
    end
end

// Negative edge domain
reg [CNT_WIDTH-1:0] neg_cnt;
reg clk_neg_reg;

always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        neg_cnt <= 0;
        clk_neg_reg <= 0;
    end else begin
        if (neg_cnt == NUM_DIV - 1) begin
            neg_cnt <= 0;
        end else begin
            neg_cnt <= neg_cnt + 1;
        end
        
        if (neg_cnt == HALF_DIV) begin
            clk_neg_reg <= ~clk_neg_reg;
        end
    end
end

// Combined output - XOR provides proper edge alignment
assign clk_div = clk_pos_reg ^ clk_neg_reg;

endmodule