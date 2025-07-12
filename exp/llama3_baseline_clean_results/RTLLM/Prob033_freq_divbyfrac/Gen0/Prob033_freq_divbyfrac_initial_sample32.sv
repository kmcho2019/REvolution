module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters for fractional division
parameter MUL2_DIV_CLK = 7; // Total clock cycles for division
parameter DIV_CLK_HIGH = 4; // Clock cycles for high phase
parameter DIV_CLK_LOW = 3; // Clock cycles for low phase

// Internal signals
reg [2:0] counter; // Counter to cycle through MUL2_DIV_CLK
reg clk_div_high; // High phase divided clock
reg clk_div_low; // Low phase divided clock
reg clk_div_high_shifted; // Phase-shifted high phase divided clock
reg clk_div_low_shifted; // Phase-shifted low phase divided clock

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b000; // Reset counter
        clk_div_high <= 1'b0; // Reset high phase divided clock
        clk_div_low <= 1'b0; // Reset low phase divided clock
        clk_div_high_shifted <= 1'b0; // Reset phase-shifted high phase divided clock
        clk_div_low_shifted <= 1'b0; // Reset phase-shifted low phase divided clock
    end else begin
        // Increment counter
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b000;
        end else begin
            counter <= counter + 1;
        end

        // Generate divided clocks based on counter value
        if (counter < DIV_CLK_HIGH) begin
            clk_div_high <= 1'b1; // High phase divided clock
        end else begin
            clk_div_high <= 1'b0;
        end

        if (counter >= MUL2_DIV_CLK - DIV_CLK_LOW) begin
            clk_div_low <= 1'b1; // Low phase divided clock
        end else begin
            clk_div_low <= 1'b0;
        end

        // Phase shift divided clocks
        if (counter == 1) begin
            clk_div_high_shifted <= 1'b1; // Phase-shifted high phase divided clock
        end else if (counter == MUL2_DIV_CLK - 2) begin
            clk_div_high_shifted <= 1'b0;
        end

        if (counter == MUL2_DIV_CLK - 1) begin
            clk_div_low_shifted <= 1'b1; // Phase-shifted low phase divided clock
        end else if (counter == DIV_CLK_HIGH) begin
            clk_div_low_shifted <= 1'b0;
        end
    end
end

// Generate final fractional divided clock output
assign clk_div = clk_div_high_shifted | clk_div_low_shifted;

endmodule