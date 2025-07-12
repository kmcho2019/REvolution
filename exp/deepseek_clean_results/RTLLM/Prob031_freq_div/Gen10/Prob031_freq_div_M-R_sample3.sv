module freq_div (
    input CLK_in,
    input RST,
    output wire CLK_50,
    output wire CLK_10,
    output wire CLK_1
);

    // Division factors
    parameter DIV_50 = 2;
    parameter DIV_10 = 10;
    parameter DIV_1 = 100;
    
    // Counter registers
    reg clk_50_reg;
    reg clk_10_reg;
    reg clk_1_reg;
    reg [2:0] cnt_10;  // Counts 0-4 (for 10MHz)
    reg [6:0] cnt_100; // Counts 0-99 (for 1MHz)
    
    // Continuous assignments for outputs
    assign CLK_50 = clk_50_reg;
    assign CLK_10 = clk_10_reg;
    assign CLK_1 = clk_1_reg;
    
    // CLK_50 generation (simple toggle)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) clk_50_reg <= 1'b0;
        else clk_50_reg <= ~clk_50_reg;
    end
    
    // CLK_10 generation counter
    always @(posedge CLK_in or posedge RST) begin
        if (RST) cnt_10 <= 0;
        else cnt_10 <= (cnt_10 == DIV_10/2-1) ? 0 : cnt_10 + 1;
    end
    
    // CLK_10 toggle logic
    always @(posedge CLK_in or posedge RST) begin
        if (RST) clk_10_reg <= 1'b0;
        else if (cnt_10 == DIV_10/2-1) clk_10_reg <= ~clk_10_reg;
    end
    
    // CLK_1 generation counter
    always @(posedge CLK_in or posedge RST) begin
        if (RST) cnt_100 <= 0;
        else cnt_100 <= (cnt_100 == DIV_1/2-1) ? 0 : cnt_100 + 1;
    end
    
    // CLK_1 toggle logic
    always @(posedge CLK_in or posedge RST) begin
        if (RST) clk_1_reg <= 1'b0;
        else if (cnt_100 == DIV_1/2-1) clk_1_reg <= ~clk_1_reg;
    end

endmodule