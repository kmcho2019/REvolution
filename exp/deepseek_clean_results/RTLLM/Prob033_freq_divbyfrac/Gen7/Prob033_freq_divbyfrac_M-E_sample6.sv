module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Parameters for 3.5x division
localparam DIV_HIGH = 4;  // 4 cycles high
localparam DIV_LOW  = 3;   // 3 cycles low
localparam DIV_TOTAL = DIV_HIGH + DIV_LOW;

// Main counter (0° phase)
reg [2:0] cnt_0;
wire cnt_0_rollover = (cnt_0 == DIV_TOTAL-1);

// Quadrature counter (180° phase)
reg [2:0] cnt_180;
wire cnt_180_rollover = (cnt_180 == DIV_TOTAL-1);

// Clock generation signals
reg clk_0;
reg clk_180;

// 0° phase counter (posedge)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_0 <= 3'b0;
    end else begin
        cnt_0 <= cnt_0_rollover ? 3'b0 : cnt_0 + 1'b1;
    end
end

// 180° phase counter (negedge)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_180 <= 3'b0;
    end else begin
        cnt_180 <= cnt_180_rollover ? 3'b0 : cnt_180 + 1'b1;
    end
end

// 0° phase clock generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_0 <= 1'b0;
    end else begin
        clk_0 <= (cnt_0 < DIV_HIGH) ? 1'b1 : 1'b0;
    end
end

// 180° phase clock generation
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_180 <= 1'b0;
    end else begin
        clk_180 <= (cnt_180 < DIV_HIGH) ? 1'b1 : 1'b0;
    end
end

// Phase interpolation with glitch prevention
reg clk_div_reg;
always @(*) begin
    if (clk) begin
        clk_div_reg = clk_0;
    end else begin
        clk_div_reg = clk_180;
    end
end

assign clk_div = clk_div_reg;

endmodule