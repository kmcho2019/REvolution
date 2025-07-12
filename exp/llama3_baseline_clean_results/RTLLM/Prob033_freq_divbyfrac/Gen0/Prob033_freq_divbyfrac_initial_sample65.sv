module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Define constants for fractional division
parameter MUL2_DIV_CLK = 7; // Total clock cycles for 3.5x division
parameter DIV_CLK_CYCLES_1 = 4; // Clock cycles for first divided clock period
parameter DIV_CLK_CYCLES_2 = 3; // Clock cycles for second divided clock period

// Internal signals
reg [2:0] counter; // Counter to keep track of clock cycles
reg clk_div_int1; // Intermediate divided clock signal 1
reg clk_div_int2; // Intermediate divided clock signal 2
reg clk_div_delayed; // Delayed version of intermediate clock signal 1
reg clk_div_advanced; // Advanced version of intermediate clock signal 2

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000;
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
        clk_div_delayed <= 1'b0;
        clk_div_advanced <= 1'b0;
    end else begin
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b000;
        end else begin
            counter <= counter + 1'b1;
        end
        
        // Generate intermediate divided clock signals
        if (counter == DIV_CLK_CYCLES_1 - 1) begin
            clk_div_int1 <= 1'b1;
        end else if (counter == DIV_CLK_CYCLES_1) begin
            clk_div_int1 <= 1'b0;
        end
        
        if (counter == MUL2_DIV_CLK - 1) begin
            clk_div_int2 <= 1'b1;
        end else if (counter == 0) begin
            clk_div_int2 <= 1'b0;
        end
        
        // Phase-shift intermediate clock signals
        if (counter == DIV_CLK_CYCLES_1 - 1) begin
            clk_div_delayed <= 1'b1;
        end else if (counter == DIV_CLK_CYCLES_1 + 1) begin
            clk_div_delayed <= 1'b0;
        end
        
        if (counter == MUL2_DIV_CLK - 2) begin
            clk_div_advanced <= 1'b1;
        end else if (counter == 0) begin
            clk_div_advanced <= 1'b0;
        end
    end
end

// Generate final fractional divided clock output
assign clk_div = clk_div_int1 | clk_div_delayed | clk_div_advanced;

endmodule