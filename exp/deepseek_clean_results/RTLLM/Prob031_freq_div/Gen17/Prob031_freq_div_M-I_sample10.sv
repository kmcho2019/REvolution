module freq_div (
    input wire CLK_in,
    input wire RST,
    output wire CLK_50,
    output wire CLK_10,
    output wire CLK_1
);

    // CLK_50 generation (divide by 2)
    reg clk_50_reg;
    always @(posedge CLK_in or posedge RST) begin
        if (RST) clk_50_reg <= 1'b0;
        else clk_50_reg <= ~clk_50_reg;
    end
    assign CLK_50 = clk_50_reg;

    // Shared comparator logic
    wire clk_10_en, clk_1_en;
    
    // CLK_10 generation (divide by 10) using Gray code counter
    reg [2:0] cnt_10_gray;
    reg clk_10_reg;
    
    // Gray code sequence for 0-4 count
    wire [2:0] gray_next_10 = (cnt_10_gray == 3'b000) ? 3'b001 :
                             (cnt_10_gray == 3'b001) ? 3'b011 :
                             (cnt_10_gray == 3'b011) ? 3'b010 :
                             (cnt_10_gray == 3'b010) ? 3'b110 : 3'b000;
    
    assign clk_10_en = (cnt_10_gray == 3'b110);
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_10_gray <= 3'b000;
            clk_10_reg <= 1'b0;
        end
        else begin
            cnt_10_gray <= gray_next_10;
            if (clk_10_en) clk_10_reg <= ~clk_10_reg;
        end
    end
    assign CLK_10 = clk_10_reg;

    // CLK_1 generation (divide by 100) using cascaded dividers
    // First divide by 10 (using CLK_10 as base), then divide by 10 again
    reg [2:0] cnt_1_gray;
    reg clk_1_reg;
    
    // Gray code sequence for 0-4 count
    wire [2:0] gray_next_1 = (cnt_1_gray == 3'b000) ? 3'b001 :
                            (cnt_1_gray == 3'b001) ? 3'b011 :
                            (cnt_1_gray == 3'b011) ? 3'b010 :
                            (cnt_1_gray == 3'b010) ? 3'b110 : 3'b000;
    
    assign clk_1_en = (cnt_1_gray == 3'b110);
    
    // Clock gating - only count when CLK_10 toggles
    wire clk_1_count_en = clk_10_en;
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_1_gray <= 3'b000;
            clk_1_reg <= 1'b0;
        end
        else if (clk_1_count_en) begin
            cnt_1_gray <= gray_next_1;
            if (clk_1_en) clk_1_reg <= ~clk_1_reg;
        end
    end
    assign CLK_1 = clk_1_reg;

endmodule