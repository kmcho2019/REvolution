module freq_div (
    input wire CLK_in,
    input wire RST,
    output wire CLK_50,
    output wire CLK_10,
    output wire CLK_1
);

    // Shared 7-bit counter (0-99)
    reg [6:0] shared_cnt;
    always @(posedge CLK_in or posedge RST) begin
        if (RST) shared_cnt <= 7'd0;
        else shared_cnt <= (shared_cnt == 7'd99) ? 7'd0 : shared_cnt + 1'b1;
    end

    // CLK_50 generation (toggle every 50 cycles)
    reg clk_50_reg;
    always @(posedge CLK_in or posedge RST) begin
        if (RST) clk_50_reg <= 1'b0;
        else if (shared_cnt == 7'd49) clk_50_reg <= ~clk_50_reg;
    end
    assign CLK_50 = clk_50_reg;

    // CLK_10 generation (toggle every 10 cycles, phase aligned to counter 0)
    reg clk_10_reg;
    always @(posedge CLK_in or posedge RST) begin
        if (RST) clk_10_reg <= 1'b0;
        else if (shared_cnt[3:0] == 4'd9) clk_10_reg <= ~clk_10_reg;
    end
    assign CLK_10 = clk_10_reg;

    // CLK_1 generation (toggle every 100 cycles)
    reg clk_1_reg;
    always @(posedge CLK_in or posedge RST) begin
        if (RST) clk_1_reg <= 1'b0;
        else if (shared_cnt == 7'd99) clk_1_reg <= ~clk_1_reg;
    end
    assign CLK_1 = clk_1_reg;

endmodule