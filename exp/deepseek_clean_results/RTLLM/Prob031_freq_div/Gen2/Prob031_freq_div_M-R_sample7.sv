module freq_div (
    input CLK_in,
    input RST,
    output CLK_50,
    output CLK_10,
    output CLK_1
);

    // 50MHz clock - simple toggle every cycle
    reg clk_50_reg;
    assign CLK_50 = clk_50_reg;
    
    // 10MHz clock - divide by 10 (toggle every 5 cycles)
    reg [2:0] cnt_10;
    reg clk_10_reg;
    assign CLK_10 = clk_10_reg;
    
    // 1MHz clock - divide by 100 (toggle every 50 cycles)
    reg [5:0] cnt_100;
    reg clk_1_reg;
    assign CLK_1 = clk_1_reg;
    
    // 50MHz generation
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            clk_50_reg <= 0;
        end else begin
            clk_50_reg <= ~clk_50_reg;
        end
    end
    
    // 10MHz generation
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_10 <= 0;
            clk_10_reg <= 0;
        end else begin
            if (cnt_10 == 4) begin
                cnt_10 <= 0;
                clk_10_reg <= ~clk_10_reg;
            end else begin
                cnt_10 <= cnt_10 + 1;
            end
        end
    end
    
    // 1MHz generation
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_100 <= 0;
            clk_1_reg <= 0;
        end else begin
            if (cnt_100 == 49) begin
                cnt_100 <= 0;
                clk_1_reg <= ~clk_1_reg;
            end else begin
                cnt_100 <= cnt_100 + 1;
            end
        end
    end

endmodule