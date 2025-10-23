module freq_div (
    input CLK_in,
    input RST,
    output wire CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Division factors
    parameter DIV_50 = 2;
    parameter DIV_10 = 10;
    parameter DIV_1 = 100;
    
    // Counter for 10MHz clock (divide by 10)
    reg [2:0] cnt_10;  // Counts 0-4
    
    // Counter for 1MHz clock (divide by 100)
    reg [5:0] cnt_100; // Counts 0-49
    
    // Simple toggle for CLK_50 (divide by 2)
    reg clk_50_reg;
    assign CLK_50 = clk_50_reg;
    
    // CLK_50 generation (continuous assignment style)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) clk_50_reg <= 1'b0;
        else clk_50_reg <= ~clk_50_reg;
    end
    
    // CLK_10 generation
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_10 <= 0;
            CLK_10 <= 0;
        end else begin
            cnt_10 <= (cnt_10 == (DIV_10/2 - 1)) ? 0 : cnt_10 + 1;
            if (cnt_10 == (DIV_10/2 - 1)) CLK_10 <= ~CLK_10;
        end
    end
    
    // CLK_1 generation
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_100 <= 0;
            CLK_1 <= 0;
        end else begin
            cnt_100 <= (cnt_100 == (DIV_1/2 - 1)) ? 0 : cnt_100 + 1;
            if (cnt_100 == (DIV_1/2 - 1)) CLK_1 <= ~CLK_1;
        end
    end

endmodule