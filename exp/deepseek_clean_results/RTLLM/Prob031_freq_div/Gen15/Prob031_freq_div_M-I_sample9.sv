module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Division ratios
    localparam DIV_50 = 2;    // 100MHz / 2 = 50MHz
    localparam DIV_10 = 10;   // 100MHz / 10 = 10MHz
    localparam DIV_1  = 100;  // 100MHz / 100 = 1MHz
    
    // Single counter for both 10MHz and 1MHz generation
    localparam MAIN_CNT_WIDTH = $clog2(DIV_1);
    reg [MAIN_CNT_WIDTH-1:0] main_cnt;

    // Clock gating signals
    wire cnt_enable = (main_cnt != DIV_1-1) || (CLK_10 || CLK_1);

    // CLK_50 generation (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // Main counter for both CLK_10 and CLK_1
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            main_cnt <= 0;
            CLK_10 <= 1'b0;
            CLK_1 <= 1'b0;
        end else if (cnt_enable) begin
            if (main_cnt == DIV_1-1) begin
                main_cnt <= 0;
                CLK_1 <= ~CLK_1;
            end else begin
                main_cnt <= main_cnt + 1'b1;
            end

            // CLK_10 toggles every DIV_10/2 counts
            if (main_cnt % (DIV_10/2) == (DIV_10/2)-1) begin
                CLK_10 <= ~CLK_10;
            end
        end
    end

endmodule