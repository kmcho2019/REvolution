module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters for 3.5x division (MUL2_DIV_CLK = 7)
localparam MUL2_DIV_CLK = 7;
localparam DIV_CLK_4 = 4; // Clock cycles for one intermediate clock
localparam DIV_CLK_3 = 3; // Clock cycles for the other intermediate clock

// Counter for cycling through MUL2_DIV_CLK clock cycles
reg [2:0] count;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        count <= 3'b000;
    end else if (count == MUL2_DIV_CLK - 1) begin
        count <= 3'b000;
    end else begin
        count <= count + 1;
    end
end

// Generate intermediate clocks
reg clk_div_4, clk_div_3;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_4 <= 1'b0;
        clk_div_3 <= 1'b0;
    end else begin
        if (count < DIV_CLK_4) begin
            clk_div_4 <= 1'b1;
        end else begin
            clk_div_4 <= 1'b0;
        end
        if (count < DIV_CLK_3) begin
            clk_div_3 <= 1'b1;
        end else begin
            clk_div_3 <= 1'b0;
        end
    end
end

// Phase-shifted clocks using double-edge clocking
reg clk_div_4_dly, clk_div_3_adv;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_4_dly <= 1'b0;
        clk_div_3_adv <= 1'b0;
    end else begin
        // Delay clk_div_4 by half a clock cycle
        if (count == DIV_CLK_4 - 1) begin
            clk_div_4_dly <= 1'b1;
        end else if (count == MUL2_DIV_CLK - 1) begin
            clk_div_4_dly <= 1'b0;
        end else begin
            clk_div_4_dly <= clk_div_4_dly;
        end
        
        // Advance clk_div_3 by half a clock cycle
        if (count == 0) begin
            clk_div_3_adv <= 1'b1;
        end else if (count == DIV_CLK_3) begin
            clk_div_3_adv <= 1'b0;
        end else begin
            clk_div_3_adv <= clk_div_3_adv;
        end
    end
end

// Final fractional divided clock output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0;
    end else begin
        clk_div <= clk_div_4_dly | clk_div_3_adv;
    end
end

endmodule