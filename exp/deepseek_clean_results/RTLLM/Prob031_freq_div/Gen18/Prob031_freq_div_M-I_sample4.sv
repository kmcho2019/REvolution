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

    // Shared counter width (enough for 1:100 division)
    localparam CNT_WIDTH = $clog2(DIV_1);
    reg [CNT_WIDTH-1:0] cnt;

    // CLK_50 generation (divide by 2)
    reg clk_50_reg;
    always @(posedge CLK_in or posedge RST) begin
        if (RST) clk_50_reg <= 1'b0;
        else clk_50_reg <= ~clk_50_reg;
    end
    assign CLK_50 = clk_50_reg;

    // Shared counter logic
    always @(posedge CLK_in or posedge RST) begin
        if (RST) cnt <= 0;
        else cnt <= (cnt == DIV_1-1) ? 0 : cnt + 1;
    end

    // CLK_10 generation (divide by 10)
    reg clk_10_reg;
    wire clk_10_en = (cnt % (DIV_10/2) == 0) && (cnt < DIV_10);
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) clk_10_reg <= 1'b0;
        else if (clk_10_en) clk_10_reg <= ~clk_10_reg;
    end
    assign CLK_10 = clk_10_reg;

    // CLK_1 generation (divide by 100)
    reg clk_1_reg;
    wire clk_1_en = (cnt == DIV_1/2-1) || (cnt == DIV_1-1);
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) clk_1_reg <= 1'b0;
        else if (clk_1_en) clk_1_reg <= ~clk_1_reg;
    end
    assign CLK_1 = clk_1_reg;

endmodule