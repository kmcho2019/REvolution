module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Define constants
localparam MUL2_DIV_CLK = 7; // Total clock cycles for 3.5x division
localparam HIGH_PERIOD = 4; // Clock cycles for high phase
localparam LOW_PERIOD = 3; // Clock cycles for low phase

// Internal signals
reg [2:0] counter; // Counter to track clock cycles
reg clk_div_high; // High phase divided clock
reg clk_div_low; // Low phase divided clock
reg clk_div_high_delayed; // Delayed high phase divided clock
reg clk_div_low_advanced; // Advanced low phase divided clock

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000; // Reset counter
    end else if (counter == MUL2_DIV_CLK - 1) begin
        counter <= 3'b000; // Reset counter after reaching max value
    end else begin
        counter <= counter + 1; // Increment counter
    end
end

// Generate uneven clock periods
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_high <= 1'b0; // Reset high phase divided clock
        clk_div_low <= 1'b0; // Reset low phase divided clock
    end else if (counter < HIGH_PERIOD) begin
        clk_div_high <= 1'b1; // High phase divided clock
        clk_div_low <= 1'b0; // Low phase divided clock
    end else begin
        clk_div_high <= 1'b0; // High phase divided clock
        clk_div_low <= 1'b1; // Low phase divided clock
    end
end

// Phase-shifting logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_high_delayed <= 1'b0; // Reset delayed high phase divided clock
        clk_div_low_advanced <= 1'b0; // Reset advanced low phase divided clock
    end else begin
        clk_div_high_delayed <= clk_div_high && (counter != MUL2_DIV_CLK - 1); // Delay high phase divided clock
        clk_div_low_advanced <= (clk_div_low && (counter != 0)) || (counter == MUL2_DIV_CLK - 1); // Advance low phase divided clock
    end
end

// Final divided clock output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0; // Reset divided clock output
    end else begin
        clk_div <= clk_div_high_delayed || clk_div_low_advanced; // OR phase-shifted clocks
    end
end

endmodule