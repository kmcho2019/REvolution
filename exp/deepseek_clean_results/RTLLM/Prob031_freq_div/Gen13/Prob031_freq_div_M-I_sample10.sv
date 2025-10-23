module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Parameters for division factors
    parameter DIV_50 = 2;
    parameter DIV_10 = 10;
    parameter DIV_1 = 100;
    
    // Calculate counter widths and terminal counts
    localparam CNT_10_WIDTH = $clog2(DIV_10);
    localparam CNT_1_WIDTH = $clog2(DIV_1);
    localparam TERM_CNT_10 = (DIV_10/2)-1;
    localparam TERM_CNT_1 = (DIV_1/2)-1;

    // Gray code counters
    reg [CNT_10_WIDTH-1:0] cnt_10;
    reg [CNT_10_WIDTH-1:0] cnt_10_gray;
    reg [CNT_1_WIDTH-1:0] cnt_100;
    reg [CNT_1_WIDTH-1:0] cnt_100_gray;

    // Clock enables
    wire clk_10_en = (cnt_10_gray == 0);
    wire clk_1_en = (cnt_100_gray == 0);

    // Binary to Gray conversion
    function automatic [CNT_10_WIDTH-1:0] bin2gray;
        input [CNT_10_WIDTH-1:0] bin;
        begin
            bin2gray = bin ^ (bin >> 1);
        end
    endfunction

    // CLK_50 generation (divide by 2)
    always @(posedge CLK_in) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // CLK_10 generation (divide by 10)
    always @(posedge CLK_in) begin
        if (RST) begin
            CLK_10 <= 1'b0;
            cnt_10 <= 0;
            cnt_10_gray <= 0;
        end else begin
            if (cnt_10 == TERM_CNT_10) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 0;
                cnt_10_gray <= 0;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
                cnt_10_gray <= bin2gray(cnt_10 + 1'b1);
            end
        end
    end

    // CLK_1 generation (divide by 100)
    always @(posedge CLK_in) begin
        if (RST) begin
            CLK_1 <= 1'b0;
            cnt_100 <= 0;
            cnt_100_gray <= 0;
        end else begin
            if (cnt_100 == TERM_CNT_1) begin
                CLK_1 <= ~CLK_1;
                cnt_100 <= 0;
                cnt_100_gray <= 0;
            end else begin
                cnt_100 <= cnt_100 + 1'b1;
                cnt_100_gray <= bin2gray(cnt_100 + 1'b1);
            end
        end
    end

endmodule