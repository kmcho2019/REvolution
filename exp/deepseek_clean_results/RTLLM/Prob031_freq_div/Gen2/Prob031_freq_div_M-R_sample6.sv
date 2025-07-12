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
    
    // Counter widths based on division factors
    localparam CNT_10_WIDTH = $clog2(DIV_10/2);
    localparam CNT_1_WIDTH = $clog2(DIV_1/2);

    // Counter for 10MHz clock (divide by 10)
    reg [CNT_10_WIDTH-1:0] cnt_10;
    wire clk_10_en = (cnt_10 == 0);
    
    // Counter for 1MHz clock (divide by 100)
    reg [CNT_1_WIDTH-1:0] cnt_100;
    wire clk_1_en = (cnt_100 == 0);

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
            cnt_10 <= (DIV_10/2)-1;
            CLK_10 <= 1'b0;
        end else begin
            if (clk_10_en) begin
                cnt_10 <= (DIV_10/2)-1;
                CLK_10 <= ~CLK_10;
            end else begin
                cnt_10 <= cnt_10 - 1'b1;
            end
        end
    end

    // CLK_1 generation (divide by 100)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_100 <= (DIV_1/2)-1;
            CLK_1 <= 1'b0;
        end else begin
            if (clk_1_en) begin
                cnt_100 <= (DIV_1/2)-1;
                CLK_1 <= ~CLK_1;
            end else begin
                cnt_100 <= cnt_100 - 1'b1;
            end
        end
    end

endmodule