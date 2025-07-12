module freq_div(
    input           CLK_in,
    input           RST,
    output          CLK_50,
    output          CLK_10,
    output          CLK_1
);

reg     clk_50_reg;
reg     clk_10_reg;
reg     clk_1_reg;
reg [1:0] cnt_2;
reg [3:0] cnt_10;
reg [5:0] cnt_100;

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        clk_50_reg <= 0;
        cnt_2 <= 0;
        clk_10_reg <= 0;
        cnt_10 <= 0;
        clk_1_reg <= 0;
        cnt_100 <= 0;
    end else begin
        // Generate CLK_50
        if (cnt_2 == 1) begin
            cnt_2 <= 0;
            clk_50_reg <= ~clk_50_reg;
        end else begin
            cnt_2 <= cnt_2 + 1;
        end
        
        // Generate CLK_10
        if (cnt_10 == 4) begin
            cnt_10 <= 0;
            clk_10_reg <= ~clk_10_reg;
        end else begin
            cnt_10 <= cnt_10 + 1;
        end
        
        // Generate CLK_1
        if (cnt_100 == 49) begin
            cnt_100 <= 0;
            clk_1_reg <= ~clk_1_reg;
        end else begin
            cnt_100 <= cnt_100 + 1;
        end
    end
end

assign CLK_50 = clk_50_reg;
assign CLK_10 = clk_10_reg;
assign CLK_1 = clk_1_reg;

endmodule