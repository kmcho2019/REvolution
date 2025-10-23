module freq_div (
    input CLK_in,
    input RST,
    output wire CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // CLK_50 generation (divide by 2) - simple toggle flip-flop
    reg clk_50_reg;
    assign CLK_50 = clk_50_reg;
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            clk_50_reg <= 1'b0;
        end else begin
            clk_50_reg <= ~clk_50_reg;
        end
    end

    // CLK_10 generation (divide by 10) - cascaded from CLK_50
    reg [1:0] cnt_10;  // Only needs 2 bits (counts 0-4)
    wire clk_10_en = (cnt_10 == 2'd4);
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_10 <= 1'b0;
            cnt_10 <= 2'b0;
        end else if (clk_50_reg) begin  // Only count on CLK_50 edges
            if (clk_10_en) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 2'b0;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end
        end
    end

    // CLK_1 generation (divide by 100) - cascaded from CLK_10
    reg [3:0] cnt_100;  // Only needs 4 bits (counts 0-9)
    wire clk_1_en = (cnt_100 == 4'd9);
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_1 <= 1'b0;
            cnt_100 <= 4'b0;
        end else if (clk_10_en) begin  // Only count on CLK_10 edges
            if (clk_1_en) begin
                CLK_1 <= ~CLK_1;
                cnt_100 <= 4'b0;
            end else begin
                cnt_100 <= cnt_100 + 1'b1;
            end
        end
    end

endmodule