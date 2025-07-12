module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Parameters for flexibility
    parameter DIV_50 = 2;
    parameter DIV_10 = 5;
    parameter DIV_1 = 10;

    // Gray code counters
    reg [1:0] cnt_50_gray;  // For 50MHz (divide by 2)
    reg [2:0] cnt_10_gray;  // For 10MHz (divide by 10)
    reg [3:0] cnt_1_gray;   // For 1MHz (divide by 100)

    // Clock enable signals
    wire clk_50_en;
    wire clk_10_en;
    wire clk_1_en;

    // Binary to Gray conversion functions
    function [1:0] bin2gray_2bit;
        input [1:0] bin;
        begin
            bin2gray_2bit = {bin[1], bin[1] ^ bin[0]};
        end
    endfunction

    function [2:0] bin2gray_3bit;
        input [2:0] bin;
        begin
            bin2gray_3bit = {bin[2], bin[2] ^ bin[1], bin[1] ^ bin[0]};
        end
    endfunction

    function [3:0] bin2gray_4bit;
        input [3:0] bin;
        begin
            bin2gray_4bit = {bin[3], bin[3] ^ bin[2], bin[2] ^ bin[1], bin[1] ^ bin[0]};
        end
    endfunction

    // 50MHz divider (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_50_gray <= 2'b00;
            CLK_50 <= 1'b0;
        end else begin
            cnt_50_gray <= bin2gray_2bit(cnt_50_gray + 1'b1);
            if (cnt_50_gray == 2'b01) // Gray code for 1
                CLK_50 <= ~CLK_50;
        end
    end

    // Clock gating for 10MHz divider
    assign clk_50_en = (cnt_50_gray == 2'b01); // Enable every 2 cycles

    // 10MHz divider (divide by 10 total, 5 from previous stage)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_10_gray <= 3'b000;
            CLK_10 <= 1'b0;
        end else if (clk_50_en) begin
            cnt_10_gray <= bin2gray_3bit(cnt_10_gray + 1'b1);
            if (cnt_10_gray == 3'b010) // Gray code for 2 (half of DIV_10-1)
                CLK_10 <= ~CLK_10;
            else if (cnt_10_gray == 3'b110) // Gray code for 4 (DIV_10-1)
                cnt_10_gray <= 3'b000;
        end
    end

    // Clock gating for 1MHz divider
    assign clk_10_en = (cnt_10_gray == 3'b010) || (cnt_10_gray == 3'b110);

    // 1MHz divider (divide by 100 total, 10 from previous stage)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_1_gray <= 4'b0000;
            CLK_1 <= 1'b0;
        end else if (clk_10_en) begin
            cnt_1_gray <= bin2gray_4bit(cnt_1_gray + 1'b1);
            if (cnt_1_gray == 4'b0100) // Gray code for 4 (half of DIV_1-1)
                CLK_1 <= ~CLK_1;
            else if (cnt_1_gray == 4'b1001) // Gray code for 9 (DIV_1-1)
                cnt_1_gray <= 4'b0000;
        end
    end

endmodule