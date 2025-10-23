module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Division parameters
    parameter DIV_50 = 2;
    parameter DIV_10 = 10;
    parameter DIV_1 = 100;
    
    // Pre-calculated terminal counts
    localparam TERM_10 = (DIV_10/2)-1;
    localparam TERM_1 = (DIV_1/2)-1;
    
    // Optimal counter widths
    localparam CNT_10_WIDTH = $clog2(DIV_10/2);
    localparam CNT_1_WIDTH = $clog2(DIV_1/2);

    // Counters and enables
    reg [CNT_10_WIDTH-1:0] cnt_10;
    reg [CNT_1_WIDTH-1:0] cnt_1;
    wire clk_10_en = (cnt_10 == TERM_10);
    wire clk_1_en = (cnt_1 == TERM_1);

    // CLK_50: Simple toggle (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // CLK_10: Divide by 10 (count up to 4)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_10 <= 1'b0;
            cnt_10 <= 0;
        end else begin
            if (clk_10_en) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 0;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end
        end
    end

    // CLK_1: Divide by 100 (count up to 49)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_1 <= 1'b0;
            cnt_1 <= 0;
        end else begin
            if (clk_1_en) begin
                CLK_1 <= ~CLK_1;
                cnt_1 <= 0;
            end else begin
                cnt_1 <= cnt_1 + 1'b1;
            end
        end
    end

endmodule