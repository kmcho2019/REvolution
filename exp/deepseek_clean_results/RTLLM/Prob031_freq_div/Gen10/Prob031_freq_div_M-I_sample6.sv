module freq_div (
    input CLK_in,
    input RST,
    output CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Fully parameterized division factors
    parameter DIV_50 = 2;
    parameter DIV_10 = 10;
    parameter DIV_1 = 100;
    
    // Calculated counter limits
    localparam CNT_10_LIMIT = (DIV_10/2)-1;
    localparam CNT_1_LIMIT = (DIV_1/2)-1;
    
    // Optimized counters
    reg [1:0] cnt_10;  // Reduced from 3-bit to 2-bit (counts 0-4)
    reg [6:0] cnt_100; // Counts 0-99 (7 bits needed)
    
    // Toggle flip-flop for 50MHz clock
    reg clk_50_reg;
    assign CLK_50 = clk_50_reg;

    // Clock gating signals
    wire cnt_10_en = (cnt_10 < CNT_10_LIMIT) || (CLK_10 == 1'b0);
    wire cnt_100_en = (cnt_100 < CNT_1_LIMIT) || (CLK_1 == 1'b0);

    // 50MHz clock generation (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            clk_50_reg <= 1'b0;
        end else begin
            clk_50_reg <= ~clk_50_reg;
        end
    end

    // 10MHz clock generation (divide by 10)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_10 <= 2'b0;
            CLK_10 <= 1'b0;
        end else if (cnt_10_en) begin
            if (cnt_10 == CNT_10_LIMIT) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 2'b0;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end
        end
    end

    // 1MHz clock generation (divide by 100)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_100 <= 7'b0;
            CLK_1 <= 1'b0;
        end else if (cnt_100_en) begin
            if (cnt_100 == CNT_1_LIMIT) begin
                CLK_1 <= ~CLK_1;
                cnt_100 <= 7'b0;
            end else begin
                cnt_100 <= cnt_100 + 1'b1;
            end
        end
    end

endmodule