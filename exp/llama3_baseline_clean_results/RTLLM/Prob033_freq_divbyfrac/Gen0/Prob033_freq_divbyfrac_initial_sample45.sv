module freq_divbyfrac(
    input clk,     // Input clock signal
    input rst_n,   // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Define parameters for the fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Counter cycles through 7 clock cycles
parameter DIV_CLK_LONG = 4;  // Long clock period (4 source clock cycles)
parameter DIV_CLK_SHORT = 3;  // Short clock period (3 source clock cycles)

// Internal signals
reg [2:0] counter;  // Counter to track clock cycles
reg clk_div_long;  // Long divided clock signal
reg clk_div_short;  // Short divided clock signal
reg clk_div_long_dly;  // Delayed long divided clock signal
reg clk_div_short_adv;  // Advanced short divided clock signal

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000;  // Initialize counter on reset
    end else begin
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b000;  // Reset counter after reaching maximum value
        end else begin
            counter <= counter + 1;  // Increment counter on each clock cycle
        end
    end
end

// Long divided clock signal generation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_long <= 1'b0;  // Initialize long divided clock signal on reset
    end else begin
        if (counter == DIV_CLK_LONG - 1) begin
            clk_div_long <= 1'b1;  // Set long divided clock signal high after DIV_CLK_LONG - 1 clock cycles
        end else if (counter == DIV_CLK_LONG + (MUL2_DIV_CLK - DIV_CLK_LONG) / 2) begin
            clk_div_long <= 1'b0;  // Set long divided clock signal low after (MUL2_DIV_CLK - DIV_CLK_LONG) / 2 additional clock cycles
        end
    end
end

// Short divided clock signal generation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_short <= 1'b0;  // Initialize short divided clock signal on reset
    end else begin
        if (counter == DIV_CLK_SHORT - 1 + (MUL2_DIV_CLK - DIV_CLK_SHORT) / 2) begin
            clk_div_short <= 1'b1;  // Set short divided clock signal high after DIV_CLK_SHORT - 1 + (MUL2_DIV_CLK - DIV_CLK_SHORT) / 2 clock cycles
        end else if (counter == MUL2_DIV_CLK - 1) begin
            clk_div_short <= 1'b0;  // Set short divided clock signal low after MUL2_DIV_CLK - 1 clock cycles
        end
    end
end

// Delayed long divided clock signal generation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_long_dly <= 1'b0;  // Initialize delayed long divided clock signal on reset
    end else begin
        clk_div_long_dly <= clk_div_long;  // Delay long divided clock signal by one clock cycle
    end
end

// Advanced short divided clock signal generation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_short_adv <= 1'b0;  // Initialize advanced short divided clock signal on reset
    end else begin
        if (counter == DIV_CLK_SHORT - 2 + (MUL2_DIV_CLK - DIV_CLK_SHORT) / 2) begin
            clk_div_short_adv <= 1'b1;  // Set advanced short divided clock signal high after DIV_CLK_SHORT - 2 + (MUL2_DIV_CLK - DIV_CLK_SHORT) / 2 clock cycles
        end else if (counter == MUL2_DIV_CLK - 2) begin
            clk_div_short_adv <= 1'b0;  // Set advanced short divided clock signal low after MUL2_DIV_CLK - 2 clock cycles
        end
    end
end

// Final divided clock signal generation
assign clk_div = clk_div_long_dly | clk_div_short_adv;  // OR delayed long divided clock signal and advanced short divided clock signal

endmodule