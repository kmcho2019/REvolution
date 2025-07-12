module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Define parameters for fractional division
parameter MUL2_DIV_CLK = 7; // Counter cycles for 3.5x division
parameter DIV_CLK_LONG = 4; // Length of longer clock period
parameter DIV_CLK_SHORT = 3; // Length of shorter clock period

// Internal signals
reg [2:0] counter; // Counter to cycle through clock periods
reg clk_div_int1; // First intermediate divided clock
reg clk_div_int2; // Second intermediate divided clock
reg clk_div_int1_dly; // Delayed version of first intermediate clock
reg clk_div_int2_adv; // Advanced version of second intermediate clock

// Counter logic
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000; // Reset counter
        clk_div_int1 <= 1'b0; // Reset first intermediate clock
        clk_div_int2 <= 1'b0; // Reset second intermediate clock
    end else if (counter == MUL2_DIV_CLK - 1) begin
        counter <= 3'b000; // Wrap counter around
    end else begin
        counter <= counter + 1'b1; // Increment counter
    end
end

// Generate intermediate divided clocks
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
    end else if (counter == DIV_CLK_LONG - 1) begin
        clk_div_int1 <= 1'b1; // Set first intermediate clock high
    end else if (counter == MUL2_DIV_CLK - 1) begin
        clk_div_int1 <= 1'b0; // Set first intermediate clock low
    end else begin
        clk_div_int1 <= clk_div_int1;
    end
    
    if (~rst_n) begin
        clk_div_int2 <= 1'b0;
    end else if (counter == DIV_CLK_SHORT - 1) begin
        clk_div_int2 <= 1'b1; // Set second intermediate clock high
    end else if (counter == DIV_CLK_LONG) begin
        clk_div_int2 <= 1'b0; // Set second intermediate clock low
    end else begin
        clk_div_int2 <= clk_div_int2;
    end
end

// Phase-shift intermediate clocks
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_int1_dly <= 1'b0;
        clk_div_int2_adv <= 1'b0;
    end else begin
        clk_div_int1_dly <= clk_div_int1; // Delay first intermediate clock
        clk_div_int2_adv <= clk_div_int2; // Advance second intermediate clock
    end
end

// Generate final fractional divided clock output
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0; // Reset output clock
    end else begin
        clk_div <= clk_div_int1_dly | clk_div_int2_adv; // OR phase-shifted clocks
    end
end

endmodule