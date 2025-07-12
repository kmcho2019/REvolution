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
    reg [2:0] cnt_10;
    reg clk_10_reg;
    wire clk_10_en = (cnt_10 == 3'd0);
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_10 <= 3'd4;  // Count 5 cycles (0-4)
            clk_10_reg <= 1'b0;
        end
        else begin
            if (clk_10_en) begin
                cnt_10 <= 3'd4;
                clk_10_reg <= ~clk_10_reg;
            end
            else begin
                cnt_10 <= cnt_10 - 1'b1;
            end
        end
    end
    assign CLK_10 = clk_10_reg;

    // CLK_1 generation (divide by 100)
    reg [5:0] cnt_100;
    reg clk_1_reg;
    wire clk_1_en = (cnt_100 == 6'd0);
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_100 <= 6'd49;  // Count 50 cycles (0-49)
            clk_1_reg <= 1'b0;
        end
        else begin
            if (clk_1_en) begin
                cnt_100 <= 6'd49;
                clk_1_reg <= ~clk_1_reg;
            end
            else begin
                cnt_100 <= cnt_100 - 1'b1;
            end
        end
    end
    assign CLK_1 = clk_1_reg;

endmodule