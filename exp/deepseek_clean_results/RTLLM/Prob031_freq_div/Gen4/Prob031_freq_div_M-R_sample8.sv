module freq_div (
    input CLK_in,
    input RST,
    output CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Parameters for division factors
    parameter DIV_50 = 2;
    parameter DIV_10 = 10;
    parameter DIV_1 = 100;
    
    // Counter for 10MHz clock (divide by 10)
    reg [2:0] cnt_10;
    
    // Counter for 1MHz clock (divide by 100)
    reg [5:0] cnt_100;
    
    // Toggle flip-flop for 50MHz clock
    reg clk_50_reg;
    assign CLK_50 = clk_50_reg;

    // 50MHz clock generation (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            clk_50_reg <= 1'b0;
        end else begin
            clk_50_reg <= ~clk_50_reg;
        end
    end

    // 10MHz clock generation (divide by 10)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_10 <= 3'b0;
            CLK_10 <= 1'b0;
        end else begin
            if (cnt_10 == (DIV_10/2)-1) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 3'b0;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end
        end
    end

    // 1MHz clock generation (divide by 100)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_100 <= 6'b0;
            CLK_1 <= 1'b0;
        end else begin
            if (cnt_100 == (DIV_1/2)-1) begin
                CLK_1 <= ~CLK_1;
                cnt_100 <= 6'b0;
            end else begin
                cnt_100 <= cnt_100 + 1'b1;
            end
        end
    end

endmodule