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
localparam HALF_CYCLE = (NUM_DIV - 1)/2;

reg [CNT_WIDTH-1:0] cnt;
reg clk_div_reg;
wire cnt_reset = (cnt == NUM_DIV - 1);
wire toggle_high = (cnt == 0);
wire toggle_low = (cnt == HALF_CYCLE);

// Single counter operating on both edges
always @(posedge clk or negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
    end else begin
        if (cnt_reset) begin
            cnt <= 0;
        end else begin
            cnt <= cnt + 1;
        end
    end
end

// Clock generation with precise toggling
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_reg <= 0;
    end else if (toggle_high) begin
        clk_div_reg <= 1;
    end
end

always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_reg <= 0;
    end else if (toggle_low) begin
        clk_div_reg <= 0;
    end
end

assign clk_div = clk_div_reg;

endmodule