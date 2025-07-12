module freq_div (
    input wire CLK_in,
    input wire RST,
    output wire CLK_50,
    output wire CLK_10,
    output wire CLK_1
);

    // CLK_50 generation (divide by 2)
    reg clk_50_reg;
    assign CLK_50 = clk_50_reg;
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) clk_50_reg <= 1'b0;
        else clk_50_reg <= ~clk_50_reg;
    end

    // Shared counter for CLK_10 and CLK_1 generation
    reg [6:0] counter;  // 7-bit counter (0-99)
    wire clk_10_en = (counter[3:0] == 4'd4);  // Every 5 cycles (0-4)
    wire clk_1_en = (counter == 7'd49);       // Every 50 cycles (0-49)
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) counter <= 7'd0;
        else if (counter == 7'd99) counter <= 7'd0;
        else counter <= counter + 1;
    end

    // CLK_10 generation (divide by 10)
    reg clk_10_reg;
    assign CLK_10 = clk_10_reg;
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) clk_10_reg <= 1'b0;
        else if (clk_10_en) clk_10_reg <= ~clk_10_reg;
    end

    // CLK_1 generation (divide by 100)
    reg clk_1_reg;
    assign CLK_1 = clk_1_reg;
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) clk_1_reg <= 1'b0;
        else if (clk_1_en) clk_1_reg <= ~clk_1_reg;
    end

endmodule