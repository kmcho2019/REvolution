module freq_div (
    input wire CLK_in,
    input wire RST,
    output wire CLK_50,
    output wire CLK_10,
    output wire CLK_1
);

    // Unified 7-bit counter (counts 0-99)
    reg [6:0] counter;
    always @(posedge CLK_in or posedge RST) begin
        if (RST) counter <= 7'd0;
        else counter <= (counter == 7'd99) ? 7'd0 : counter + 1'b1;
    end

    // Clock gating signals
    wire clk_50_en = ~counter[0];  // Toggle every cycle (divide by 2)
    wire clk_10_en = (counter[3:0] == 4'b1001);  // Every 10 cycles
    wire clk_1_en = (counter == 7'd99);  // Every 100 cycles

    // Clock generation with gated toggle flip-flops
    reg clk_50_reg, clk_10_reg, clk_1_reg;
    
    // 50MHz clock (direct from counter bit0)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) clk_50_reg <= 1'b0;
        else if (clk_50_en) clk_50_reg <= ~clk_50_reg;
    end

    // 10MHz clock (ripple from 50MHz)
    always @(posedge clk_50_reg or posedge RST) begin
        if (RST) clk_10_reg <= 1'b0;
        else if (clk_10_en) clk_10_reg <= ~clk_10_reg;
    end

    // 1MHz clock (ripple from 10MHz)
    always @(posedge clk_10_reg or posedge RST) begin
        if (RST) clk_1_reg <= 1'b0;
        else if (clk_1_en) clk_1_reg <= ~clk_1_reg;
    end

    assign CLK_50 = clk_50_reg;
    assign CLK_10 = clk_10_reg;
    assign CLK_1 = clk_1_reg;

endmodule