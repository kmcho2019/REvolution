module freq_div (
    input wire CLK_in,
    input wire RST,
    output wire CLK_50,
    output wire CLK_10,
    output wire CLK_1
);

    // Parameters for division factors
    parameter DIV_50 = 2;
    parameter DIV_10 = 10;
    parameter DIV_1 = 100;

    // Calculate optimal counter width for the base counter
    localparam BASE_CNT_WIDTH = $clog2(DIV_1);
    
    // Base counter (counts 0-99 for 100MHz->1MHz)
    reg [BASE_CNT_WIDTH-1:0] base_cnt;
    wire base_cnt_full = (base_cnt == DIV_1-1);
    
    // Gray code conversion for lower power
    wire [BASE_CNT_WIDTH-1:0] gray_cnt;
    assign gray_cnt = base_cnt ^ (base_cnt >> 1);
    
    // Clock enables
    wire clk_50_en = 1'b1; // Always toggle for 50MHz
    wire clk_10_en = (gray_cnt[3:0] == 4'b0000); // Every 10 counts
    wire clk_1_en = base_cnt_full; // Every 100 counts
    
    // Output registers
    reg clk_50_reg, clk_10_reg, clk_1_reg;
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            base_cnt <= 0;
            clk_50_reg <= 0;
            clk_10_reg <= 0;
            clk_1_reg <= 0;
        end else begin
            // Base counter
            if (base_cnt_full)
                base_cnt <= 0;
            else
                base_cnt <= base_cnt + 1;
            
            // Clock generation with gating
            clk_50_reg <= clk_50_en ? ~clk_50_reg : clk_50_reg;
            if (clk_10_en) clk_10_reg <= ~clk_10_reg;
            if (clk_1_en) clk_1_reg <= ~clk_1_reg;
        end
    end
    
    assign CLK_50 = clk_50_reg;
    assign CLK_10 = clk_10_reg;
    assign CLK_1 = clk_1_reg;

endmodule