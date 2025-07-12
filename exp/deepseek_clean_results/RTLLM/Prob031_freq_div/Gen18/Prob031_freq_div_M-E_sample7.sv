module freq_div (
    input wire CLK_in,
    input wire RST,
    output wire CLK_50,
    output wire CLK_10,
    output wire CLK_1
);

    // 50MHz generation (divide by 2)
    reg clk_50_reg;
    always @(posedge CLK_in or posedge RST) begin
        if (RST) clk_50_reg <= 1'b0;
        else clk_50_reg <= ~clk_50_reg;
    end
    assign CLK_50 = clk_50_reg;

    // 10MHz generation (divide by 5 from 50MHz)
    reg [1:0] cnt_10;
    reg clk_10_reg;
    wire clk_10_enable = (cnt_10 == 2'd2) & clk_50_reg;
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_10 <= 2'b0;
            clk_10_reg <= 1'b0;
        end else if (clk_50_reg) begin
            if (cnt_10 == 2'd4) begin
                cnt_10 <= 2'b0;
                clk_10_reg <= ~clk_10_reg;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end
        end
    end
    assign CLK_10 = clk_10_reg;

    // 1MHz generation (divide by 10 from 10MHz)
    reg [2:0] cnt_1;
    reg clk_1_reg;
    wire clk_1_enable = (cnt_1 == 3'd9) & clk_10_reg;
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_1 <= 3'b0;
            clk_1_reg <= 1'b0;
        end else if (clk_10_reg) begin
            if (cnt_1 == 3'd9) begin
                cnt_1 <= 3'b0;
                clk_1_reg <= ~clk_1_reg;
            end else begin
                cnt_1 <= cnt_1 + 1'b1;
            end
        end
    end
    assign CLK_1 = clk_1_reg;

endmodule