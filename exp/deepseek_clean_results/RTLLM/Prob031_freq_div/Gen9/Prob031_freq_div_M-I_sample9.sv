module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Enhanced parameters for flexibility
    parameter DIV_50 = 2;
    parameter DIV_10 = 10;
    parameter DIV_1 = 100;
    
    // Calculate counter widths and terminal counts
    localparam CNT_WIDTH = $clog2(DIV_1);
    localparam TERM_CNT_50 = DIV_50/2 - 1;
    localparam TERM_CNT_10 = DIV_10/2 - 1;
    localparam TERM_CNT_1 = DIV_1/2 - 1;

    // Gray code counters
    reg [CNT_WIDTH-1:0] cnt_base;
    wire [CNT_WIDTH-1:0] cnt_gray;
    reg [CNT_WIDTH-1:0] cnt_gray_reg;
    
    // Gray code conversion
    assign cnt_gray = cnt_base ^ (cnt_base >> 1);
    
    // Clock enables
    wire clk_50_en;
    wire clk_10_en;
    wire clk_1_en;
    
    assign clk_50_en = (cnt_base[0:0] == TERM_CNT_50);
    assign clk_10_en = (cnt_base[3:0] == TERM_CNT_10);
    assign clk_1_en = (cnt_base == TERM_CNT_1);

    // Main counter (shared for all clocks)
    always @(posedge CLK_in) begin
        if (RST) begin
            cnt_base <= 0;
            cnt_gray_reg <= 0;
        end else begin
            cnt_base <= cnt_base + 1;
            cnt_gray_reg <= cnt_gray;
        end
    end

    // CLK_50 generation (divide by 2)
    always @(posedge CLK_in) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else if (clk_50_en) begin
            CLK_50 <= ~CLK_50;
        end
    end

    // CLK_10 generation (divide by 10)
    always @(posedge CLK_in) begin
        if (RST) begin
            CLK_10 <= 1'b0;
        end else if (clk_10_en) begin
            CLK_10 <= ~CLK_10;
        end
    end

    // CLK_1 generation (divide by 100)
    always @(posedge CLK_in) begin
        if (RST) begin
            CLK_1 <= 1'b0;
        end else if (clk_1_en) begin
            CLK_1 <= ~CLK_1;
        end
    end

endmodule