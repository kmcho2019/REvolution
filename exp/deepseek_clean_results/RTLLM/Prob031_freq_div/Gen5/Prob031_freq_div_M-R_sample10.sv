module freq_div (
    input CLK_in,
    input RST,
    output CLK_50,
    output CLK_10,
    output CLK_1
);

    // Parameters for division factors
    parameter DIV_50 = 2;
    parameter DIV_10 = 10;
    parameter DIV_1 = 100;
    
    // Calculate count thresholds (using down counters)
    parameter CNT_10_THRESH = (DIV_10/2) - 1;
    parameter CNT_1_THRESH = (DIV_1/2) - 1;
    
    // Counter registers
    reg [2:0] cnt_10;
    reg [5:0] cnt_100;
    reg clk_50_reg;
    
    // Clock generation logic
    assign CLK_50 = clk_50_reg;
    assign CLK_10 = (cnt_10 == 0);
    assign CLK_1 = (cnt_100 == 0);

    // Combined counter logic
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            clk_50_reg <= 1'b0;
            cnt_10 <= CNT_10_THRESH;
            cnt_100 <= CNT_1_THRESH;
        end else begin
            // 50MHz clock generation
            clk_50_reg <= ~clk_50_reg;
            
            // 10MHz counter logic
            if (cnt_10 == 0)
                cnt_10 <= CNT_10_THRESH;
            else
                cnt_10 <= cnt_10 - 1'b1;
                
            // 1MHz counter logic
            if (cnt_100 == 0)
                cnt_100 <= CNT_1_THRESH;
            else
                cnt_100 <= cnt_100 - 1'b1;
        end
    end

endmodule