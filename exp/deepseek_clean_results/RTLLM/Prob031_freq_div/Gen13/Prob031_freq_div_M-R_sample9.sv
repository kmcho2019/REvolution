module freq_div (
    input wire CLK_in,
    input wire RST,
    output wire CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Division factors
    localparam DIV_50 = 2;
    localparam DIV_10 = 10;
    localparam DIV_1 = 100;
    
    // Counter widths
    localparam CNT_10_WIDTH = $clog2(DIV_10);
    localparam CNT_1_WIDTH = $clog2(DIV_1);
    
    // Terminal counts (count to N-1)
    localparam TERM_CNT_10 = DIV_10 - 1;
    localparam TERM_CNT_1 = DIV_1 - 1;

    // CLK_50 generation (divide by 2)
    reg clk_50_reg;
    always @(posedge CLK_in) begin
        if (RST) clk_50_reg <= 1'b0;
        else clk_50_reg <= ~clk_50_reg;
    end
    assign CLK_50 = clk_50_reg;

    // CLK_10 generation (divide by 10)
    reg [CNT_10_WIDTH-1:0] cnt_10;
    always @(posedge CLK_in) begin
        if (RST) begin
            CLK_10 <= 1'b0;
            cnt_10 <= {CNT_10_WIDTH{1'b0}};
        end else begin
            if (cnt_10 == TERM_CNT_10) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= {CNT_10_WIDTH{1'b0}};
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end
        end
    end

    // CLK_1 generation (divide by 100)
    reg [CNT_1_WIDTH-1:0] cnt_100;
    always @(posedge CLK_in) begin
        if (RST) begin
            CLK_1 <= 1'b0;
            cnt_100 <= {CNT_1_WIDTH{1'b0}};
        end else begin
            if (cnt_100 == TERM_CNT_1) begin
                CLK_1 <= ~CLK_1;
                cnt_100 <= {CNT_1_WIDTH{1'b0}};
            end else begin
                cnt_100 <= cnt_100 + 1'b1;
            end
        end
    end

endmodule