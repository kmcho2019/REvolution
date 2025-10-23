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
    
    // Pre-calculated constants
    localparam DIV_10_HALF = DIV_10/2;
    localparam DIV_1_HALF = DIV_1/DIV_10; // Cascaded division
    
    // Counter widths
    localparam CNT_10_WIDTH = $clog2(DIV_10_HALF);
    localparam CNT_1_WIDTH = $clog2(DIV_1_HALF);

    // Gray code encoding for 1MHz counter (reduces switching)
    reg [CNT_1_WIDTH-1:0] cnt_100_bin;
    wire [CNT_1_WIDTH-1:0] cnt_100_gray;
    assign cnt_100_gray = (cnt_100_bin >> 1) ^ cnt_100_bin;
    
    // Clock enables
    wire clk_10_en = (cnt_100_bin == 0);
    wire clk_1_en = (cnt_100_gray == 0);

    // CLK_50 generation (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // CLK_10 generation (divide by 10)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_100_bin <= DIV_10_HALF-1;
            CLK_10 <= 1'b0;
        end else begin
            if (clk_10_en) begin
                cnt_100_bin <= DIV_10_HALF-1;
                CLK_10 <= ~CLK_10;
            end else begin
                cnt_100_bin <= cnt_100_bin - 1'b1;
            end
        end
    end

    // CLK_1 generation (cascaded divide by 10 from CLK_10)
    reg [CNT_1_WIDTH-1:0] cnt_1;
    always @(posedge CLK_10 or posedge RST) begin
        if (RST) begin
            cnt_1 <= DIV_1_HALF-1;
            CLK_1 <= 1'b0;
        end else begin
            if (cnt_1 == 0) begin
                cnt_1 <= DIV_1_HALF-1;
                CLK_1 <= ~CLK_1;
            end else begin
                cnt_1 <= cnt_1 - 1'b1;
            end
        end
    end

endmodule