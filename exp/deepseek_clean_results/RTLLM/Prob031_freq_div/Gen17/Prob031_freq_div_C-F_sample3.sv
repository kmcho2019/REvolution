module freq_div (
    input wire CLK_in,
    input wire RST,
    output wire CLK_50,
    output wire CLK_10,
    output wire CLK_1
);

    // Parameters for division factors
    parameter DIV_50 = 2;
    parameter DIV_10 = 10;
    parameter DIV_1 = 100;

    // Calculate optimal counter widths
    localparam CNT_10_WIDTH = $clog2(DIV_10/2);
    localparam CNT_1_WIDTH = $clog2(DIV_1/2);

    // CLK_50 generation (divide by 2)
    reg clk_50_reg;
    always @(posedge CLK_in or posedge RST) begin
        if (RST) clk_50_reg <= 1'b0;
        else clk_50_reg <= ~clk_50_reg;
    end
    assign CLK_50 = clk_50_reg;

    // CLK_10 generation (divide by 10)
    reg [CNT_10_WIDTH-1:0] cnt_10;
    reg clk_10_reg;
    wire clk_10_en = (cnt_10 == 0);
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_10 <= (DIV_10/2)-1;
            clk_10_reg <= 1'b0;
        end
        else begin
            if (clk_10_en) begin
                cnt_10 <= (DIV_10/2)-1;
                clk_10_reg <= ~clk_10_reg;
            end
            else begin
                cnt_10 <= cnt_10 - 1'b1;
            end
        end
    end
    assign CLK_10 = clk_10_reg;

    // CLK_1 generation (divide by 100)
    reg [CNT_1_WIDTH-1:0] cnt_100;
    reg clk_1_reg;
    wire clk_1_en = (cnt_100 == 0);
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_100 <= (DIV_1/2)-1;
            clk_1_reg <= 1'b0;
        end
        else begin
            if (clk_1_en) begin
                cnt_100 <= (DIV_1/2)-1;
                clk_1_reg <= ~clk_1_reg;
            end
            else begin
                cnt_100 <= cnt_100 - 1'b1;
            end
        end
    end
    assign CLK_1 = clk_1_reg;

endmodule