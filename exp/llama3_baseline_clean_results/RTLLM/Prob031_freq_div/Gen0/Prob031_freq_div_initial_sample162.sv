module freq_div (
    input           CLK_in,  // Input clock signal
    input           RST,     // Reset signal
    output          CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output          CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output          CLK_1    // Output clock signal with a frequency of CLK_in divided by 100
);

reg     clk_50_reg;
reg     clk_10_reg;
reg     clk_1_reg;
reg [1:0] cnt_10;
reg [5:0] cnt_100;

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        clk_50_reg <= 1'b0;
        clk_10_reg <= 1'b0;
        cnt_10 <= 2'b00;
        clk_1_reg <= 1'b0;
        cnt_100 <= 6'b000000;
    end else begin
        clk_50_reg <= ~clk_50_reg;
        
        cnt_10 <= cnt_10 + 1'b1;
        if (cnt_10 == 2'b100) begin
            cnt_10 <= 2'b00;
            clk_10_reg <= ~clk_10_reg;
        end
        
        cnt_100 <= cnt_100 + 1'b1;
        if (cnt_100 == 6'b110001) begin
            cnt_100 <= 6'b000000;
            clk_1_reg <= ~clk_1_reg;
        end
    end
end

assign CLK_50 = clk_50_reg;
assign CLK_10 = clk_10_reg;
assign CLK_1  = clk_1_reg;

endmodule