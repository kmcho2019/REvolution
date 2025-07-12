module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Division parameters
    parameter DIV_50 = 2;
    parameter DIV_10 = 10;
    parameter DIV_1 = 100;

    // Gray code counters (width optimized)
    reg [0:0] gray_50;  // 1-bit for /2
    reg [2:0] gray_10;  // 3-bit for /10
    reg [6:0] gray_1;   // 7-bit for /100

    // Binary to Gray conversion functions
    function [0:0] bin2gray_1bit;
        input [0:0] b;
        bin2gray_1bit = b;
    endfunction

    function [2:0] bin2gray_3bit;
        input [2:0] b;
        bin2gray_3bit = {b[2], b[2]^b[1], b[1]^b[0]};
    endfunction

    function [6:0] bin2gray_7bit;
        input [6:0] b;
        bin2gray_7bit = {b[6], b[6]^b[5], b[5]^b[4], b[4]^b[3],
                        b[3]^b[2], b[2]^b[1], b[1]^b[0]};
    endfunction

    // 50MHz generation (simple toggle)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 0;
            gray_50 <= 0;
        end else begin
            gray_50 <= bin2gray_1bit(~gray_50);
            CLK_50 <= gray_50[0];
        end
    end

    // 10MHz generation (divided from 50MHz)
    reg [3:0] cnt10;  // Counts 0-4 (5 cycles)
    always @(posedge CLK_50 or posedge RST) begin
        if (RST) begin
            CLK_10 <= 0;
            cnt10 <= 0;
            gray_10 <= 0;
        end else begin
            if (cnt10 == 4) begin
                cnt10 <= 0;
                gray_10 <= bin2gray_3bit(gray_10 + 1);
                CLK_10 <= gray_10[0];
            end else begin
                cnt10 <= cnt10 + 1;
            end
        end
    end

    // 1MHz generation (divided from 10MHz)
    reg [4:0] cnt100;  // Counts 0-9 (10 cycles)
    always @(posedge CLK_10 or posedge RST) begin
        if (RST) begin
            CLK_1 <= 0;
            cnt100 <= 0;
            gray_1 <= 0;
        end else begin
            if (cnt100 == 9) begin
                cnt100 <= 0;
                gray_1 <= bin2gray_7bit(gray_1 + 1);
                CLK_1 <= gray_1[0];
            end else begin
                cnt100 <= cnt100 + 1;
            end
        end
    end

endmodule