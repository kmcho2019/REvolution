module freq_diveven (
    input clk,
    input rst_n,
    output clk_div
);

parameter NUM_DIV = 4;  // Division factor (must be even)

// Validate parameter (synthesis-time check)
initial begin
    if (NUM_DIV[0] || NUM_DIV < 2) begin
        $error("NUM_DIV must be an even number >= 2");
    end
end

reg [3:0] cnt;
wire toggle = (cnt == (NUM_DIV/2 - 1));

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
    end
    else if (toggle) begin
        cnt <= 0;
    end
    else begin
        cnt <= cnt + 1;
    end
end

reg div_reg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        div_reg <= 0;
    end
    else if (toggle) begin
        div_reg <= ~div_reg;
    end
end

assign clk_div = div_reg;

endmodule