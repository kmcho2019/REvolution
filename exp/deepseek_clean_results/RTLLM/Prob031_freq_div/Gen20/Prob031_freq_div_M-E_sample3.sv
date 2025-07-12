module freq_div (
    input wire CLK_in,
    input wire RST,
    output wire CLK_50,
    output wire CLK_10,
    output wire CLK_1
);

    // Generate 50MHz clock (divide by 2)
    reg clk_50_reg;
    always @(posedge CLK_in or posedge RST) begin
        if (RST) clk_50_reg <= 1'b0;
        else clk_50_reg <= ~clk_50_reg;
    end
    assign CLK_50 = clk_50_reg;

    // Generate 10MHz clock (divide 50MHz by 5)
    reg [2:0] cnt_5;  // 3-bit counter for divide by 5 (0-4)
    reg clk_10_reg;
    
    always @(posedge clk_50_reg or posedge RST) begin
        if (RST) begin
            cnt_5 <= 3'b0;
            clk_10_reg <= 1'b0;
        end
        else begin
            if (cnt_5 == 3'd4) begin
                cnt_5 <= 3'b0;
                clk_10_reg <= ~clk_10_reg;
            end
            else begin
                cnt_5 <= cnt_5 + 1'b1;
            end
        end
    end
    assign CLK_10 = clk_10_reg;

    // Generate 1MHz clock (divide 10MHz by 10)
    reg [3:0] cnt_10;  // 4-bit counter for divide by 10 (0-9)
    reg clk_1_reg;
    
    always @(posedge clk_10_reg or posedge RST) begin
        if (RST) begin
            cnt_10 <= 4'b0;
            clk_1_reg <= 1'b0;
        end
        else begin
            if (cnt_10 == 4'd9) begin
                cnt_10 <= 4'b0;
                clk_1_reg <= ~clk_1_reg;
            end
            else begin
                cnt_10 <= cnt_10 + 1'b1;
            end
        end
    end
    assign CLK_1 = clk_1_reg;

endmodule