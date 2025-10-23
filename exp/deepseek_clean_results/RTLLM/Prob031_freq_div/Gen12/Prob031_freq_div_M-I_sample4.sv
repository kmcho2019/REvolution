module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Parameters for division factors
    parameter DIV_50 = 2;
    parameter DIV_10 = 5;  // Relative to 50MHz
    parameter DIV_1 = 10;  // Relative to 10MHz
    
    // Pre-calculated constants
    localparam CNT_10_MAX = DIV_10 - 1;
    localparam CNT_1_MAX = DIV_1 - 1;

    // Counters
    reg [3:0] cnt_10 = 0;  // 4-bit for up to DIV_10=16
    reg [3:0] cnt_1 = 0;    // 4-bit for up to DIV_1=16
    
    // Enable signals
    wire clk_10_en;
    wire clk_1_en;

    // CLK_50 generation (divide by 2)
    always @(posedge CLK_in) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // CLK_10 generation (divide by 10 total, 5 from 50MHz)
    assign clk_10_en = (cnt_10 == CNT_10_MAX);
    
    always @(posedge CLK_50 or posedge RST) begin
        if (RST) begin
            cnt_10 <= 0;
            CLK_10 <= 1'b0;
        end else begin
            if (clk_10_en) begin
                cnt_10 <= 0;
                CLK_10 <= ~CLK_10;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end
        end
    end

    // CLK_1 generation (divide by 100 total, 10 from 10MHz)
    assign clk_1_en = (cnt_1 == CNT_1_MAX);
    
    always @(posedge CLK_10 or posedge RST) begin
        if (RST) begin
            cnt_1 <= 0;
            CLK_1 <= 1'b0;
        end else begin
            if (clk_1_en) begin
                cnt_1 <= 0;
                CLK_1 <= ~CLK_1;
            end else begin
                cnt_1 <= cnt_1 + 1'b1;
            end
        end
    end

endmodule