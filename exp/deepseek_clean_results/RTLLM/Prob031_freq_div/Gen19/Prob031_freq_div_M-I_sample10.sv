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
    
    // Pre-calculated terminal counts
    localparam TERM_50 = DIV_50/2 - 1;
    localparam TERM_10 = (DIV_10/DIV_50)/2 - 1;
    localparam TERM_1 = (DIV_1/DIV_10)/2 - 1;

    // 50MHz clock (divide by 2)
    reg [0:0] cnt_50 = 0;
    reg clk_50_reg = 0;
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_50 <= 0;
            clk_50_reg <= 0;
        end else begin
            if (cnt_50 == TERM_50) begin
                cnt_50 <= 0;
                clk_50_reg <= ~clk_50_reg;
            end else begin
                cnt_50 <= cnt_50 + 1'b1;
            end
        end
    end
    assign CLK_50 = clk_50_reg;

    // 10MHz clock (divide by 10, cascaded from 50MHz)
    reg [1:0] cnt_10 = 0;
    reg clk_10_reg = 0;
    always @(posedge CLK_50 or posedge RST) begin
        if (RST) begin
            cnt_10 <= 0;
            clk_10_reg <= 0;
        end else begin
            if (cnt_10 == TERM_10) begin
                cnt_10 <= 0;
                clk_10_reg <= ~clk_10_reg;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end
        end
    end
    assign CLK_10 = clk_10_reg;

    // 1MHz clock (divide by 100, cascaded from 10MHz)
    reg [2:0] cnt_1 = 0;
    reg clk_1_reg = 0;
    always @(posedge CLK_10 or posedge RST) begin
        if (RST) begin
            cnt_1 <= 0;
            clk_1_reg <= 0;
        end else begin
            if (cnt_1 == TERM_1) begin
                cnt_1 <= 0;
                clk_1_reg <= ~clk_1_reg;
            end else begin
                cnt_1 <= cnt_1 + 1'b1;
            end
        end
    end
    assign CLK_1 = clk_1_reg;

endmodule