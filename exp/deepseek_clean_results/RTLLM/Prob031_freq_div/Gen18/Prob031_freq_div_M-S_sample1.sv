module freq_div (
    input wire CLK_in,
    input wire RST,
    output wire CLK_50,
    output wire CLK_10,
    output wire CLK_1
);

    // CLK_50 generation (divide by 2)
    reg clk_50_reg;
    always @(posedge CLK_in or posedge RST) begin
        if (RST) clk_50_reg <= 1'b0;
        else clk_50_reg <= ~clk_50_reg;
    end
    assign CLK_50 = clk_50_reg;

    // CLK_10 generation (divide by 10)
    reg [2:0] cnt_10;  // counts 0-4 (5 cycles)
    reg clk_10_reg;
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_10 <= 3'b0;
            clk_10_reg <= 1'b0;
        end
        else if (cnt_10 == 3'd4) begin
            cnt_10 <= 3'b0;
            clk_10_reg <= ~clk_10_reg;
        end
        else begin
            cnt_10 <= cnt_10 + 1'b1;
        end
    end
    assign CLK_10 = clk_10_reg;

    // CLK_1 generation (divide by 100)
    reg [5:0] cnt_100;  // counts 0-49 (50 cycles)
    reg clk_1_reg;
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_100 <= 6'b0;
            clk_1_reg <= 1'b0;
        end
        else if (cnt_100 == 6'd49) begin
            cnt_100 <= 6'b0;
            clk_1_reg <= ~clk_1_reg;
        end
        else begin
            cnt_100 <= cnt_100 + 1'b1;
        end
    end
    assign CLK_1 = clk_1_reg;

endmodule