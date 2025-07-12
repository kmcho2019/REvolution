module freq_divbyfrac (
    input clk,
    input rst_n,
    output reg clk_div
);

// Define parameters for the multiplication and division factors
parameter MUL2_DIV_CLK = 7; // Total clock cycles for 3.5x division
parameter DIV_CLK_LOW = 4;  // Clock cycles for the lower period
parameter DIV_CLK_HIGH = 3; // Clock cycles for the higher period

// Internal signals for the counter and intermediate clocks
reg [2:0] counter; // Counter for tracking clock cycles
reg clk_div_int1; // Intermediate clock signal 1
reg clk_div_int2; // Intermediate clock signal 2
reg clk_div_delayed; // Delayed version of the divided clock
reg clk_div_advanced; // Advanced version of the divided clock

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b000; // Reset counter
        clk_div_int1 <= 1'b0; // Reset intermediate clock signals
        clk_div_int2 <= 1'b0;
    end else if (counter == MUL2_DIV_CLK - 1) begin
        counter <= 3'b000; // Reset counter
        clk_div_int1 <= ~clk_div_int1; // Toggle intermediate clock signals
        clk_div_int2 <= ~clk_div_int2;
    end else begin
        counter <= counter + 1; // Increment counter
    end
end

// Generate uneven clock periods
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_int1 <= 1'b0; // Reset intermediate clock signals
        clk_div_int2 <= 1'b0;
    end else if (counter == DIV_CLK_LOW - 1) begin
        clk_div_int1 <= 1'b1; // Set intermediate clock signal 1 high
    end else if (counter == MUL2_DIV_CLK - 1) begin
        clk_div_int1 <= 1'b0; // Set intermediate clock signal 1 low
    end else if (counter == DIV_CLK_HIGH) begin
        clk_div_int2 <= 1'b1; // Set intermediate clock signal 2 high
    end else if (counter == MUL2_DIV_CLK - 2) begin
        clk_div_int2 <= 1'b0; // Set intermediate clock signal 2 low
    end
end

// Apply phase-shifting (delay and advance)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_delayed <= 1'b0; // Reset delayed and advanced clocks
        clk_div_advanced <= 1'b0;
    end else begin
        clk_div_delayed <= clk_div_int1; // Delay intermediate clock signal 1
        clk_div_advanced <= clk_div_int2; // Advance intermediate clock signal 2
    end
end

// Logically OR the intermediate clocks to produce the final output
assign clk_div = clk_div_int1 | clk_div_int2 | clk_div_delayed | clk_div_advanced;

endmodule