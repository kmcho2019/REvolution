module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Enhanced parameters with better documentation
    parameter DIV_50 = 2;      // 100MHz/2 = 50MHz
    parameter DIV_10 = 10;     // 100MHz/10 = 10MHz
    parameter DIV_1 = 100;     // 100MHz/100 = 1MHz
    
    // Calculate counter widths and terminal counts
    localparam BASE_CNT_WIDTH = $clog2(DIV_1);
    localparam TERM_CNT_50 = DIV_50 - 1;
    localparam TERM_CNT_10 = DIV_10 - 1;
    localparam TERM_CNT_1 = DIV_1 - 1;

    // Shared base counter and Gray code conversion
    reg [BASE_CNT_WIDTH-1:0] base_cnt;
    wire [BASE_CNT_WIDTH-1:0] base_cnt_gray;
    reg [BASE_CNT_WIDTH-1:0] base_cnt_gray_reg;
    
    // Gray code conversion
    assign base_cnt_gray = base_cnt ^ (base_cnt >> 1);

    // Clock gating for 1MHz domain
    wire clk_1_enable = (base_cnt % DIV_1) == 0;

    // Main counter with synchronous reset
    always @(posedge CLK_in) begin
        if (RST) begin
            base_cnt <= 0;
            base_cnt_gray_reg <= 0;
        end else begin
            base_cnt <= (base_cnt == TERM_CNT_1) ? 0 : base_cnt + 1;
            base_cnt_gray_reg <= base_cnt_gray;
        end
    end

    // CLK_50 generation (divide by 2)
    always @(posedge CLK_in) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else if (base_cnt[0:0] == TERM_CNT_50) begin
            CLK_50 <= ~CLK_50;
        end
    end

    // CLK_10 generation (divide by 10)
    always @(posedge CLK_in) begin
        if (RST) begin
            CLK_10 <= 1'b0;
        end else if (base_cnt_gray_reg % DIV_10 == TERM_CNT_10) begin
            CLK_10 <= ~CLK_10;
        end
    end

    // CLK_1 generation (divide by 100) with clock gating
    always @(posedge CLK_in) begin
        if (RST) begin
            CLK_1 <= 1'b0;
        end else if (clk_1_enable) begin
            CLK_1 <= ~CLK_1;
        end
    end

endmodule