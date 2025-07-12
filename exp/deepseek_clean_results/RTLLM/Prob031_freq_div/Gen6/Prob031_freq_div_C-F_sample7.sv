module freq_div (
    input CLK_in,
    input RST,
    output wire CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Division factors (parameters for flexibility)
    parameter DIV_50 = 2;
    parameter DIV_10 = 10;
    parameter DIV_1 = 100;
    
    // Precomputed comparison values
    localparam CNT_10_MAX = (DIV_10/2) - 1;  // 4
    localparam CNT_100_MAX = (DIV_1/2) - 1;  // 49
    
    // Counters (optimized bit widths)
    reg [1:0] cnt_10;   // 2 bits for counting 0-4
    reg [5:0] cnt_100;  // 6 bits for counting 0-49
    
    // CLK_50 generation (continuous assignment)
    reg clk_50_reg;
    assign CLK_50 = clk_50_reg;
    
    // CLK_50 toggle logic
    always @(posedge CLK_in or posedge RST) begin
        if (RST) clk_50_reg <= 1'b0;
        else clk_50_reg <= ~clk_50_reg;
    end
    
    // CLK_10 generation
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_10 <= 0;
            CLK_10 <= 0;
        end else if (cnt_10 == CNT_10_MAX) begin
            cnt_10 <= 0;
            CLK_10 <= ~CLK_10;
        end else begin
            cnt_10 <= cnt_10 + 1;
        end
    end
    
    // CLK_1 generation
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_100 <= 0;
            CLK_1 <= 0;
        end else if (cnt_100 == CNT_100_MAX) begin
            cnt_100 <= 0;
            CLK_1 <= ~CLK_1;
        end else begin
            cnt_100 <= cnt_100 + 1;
        end
    end

endmodule