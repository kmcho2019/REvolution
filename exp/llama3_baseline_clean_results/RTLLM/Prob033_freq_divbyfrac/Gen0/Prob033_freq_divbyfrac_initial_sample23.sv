module freq_divbyfrac (
    input clk,
    input rst_n,
    output reg clk_div
);

// Define parameters for the division ratio and uneven clock periods
parameter MUL2_DIV_CLK = 7; // Total clock cycles for division
parameter CYCLES_LOW = 4;   // Number of source clock cycles for longer period
parameter CYCLES_HIGH = 3;  // Number of source clock cycles for shorter period

// Internal signals for counting and generating intermediate clocks
reg [2:0] cnt;              // Counter to track clock cycles
reg clk_div_int1;           // Intermediate clock 1 (normal phase)
reg clk_div_int2;           // Intermediate clock 2 (phase-shifted)
reg prev_clk;               // Previous clock value for edge detection

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Initialize counter and intermediate clocks on reset
        cnt <= 3'b000;
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
        prev_clk <= 1'b0;
    end else begin
        // Count clock cycles and generate intermediate clocks
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000; // Reset counter
            clk_div_int1 <= 1'b1; // Generate intermediate clock 1
            if (prev_clk == 1'b0) begin
                clk_div_int2 <= 1'b1; // Generate intermediate clock 2 on rising edge
            end else begin
                clk_div_int2 <= 1'b0; // Don't generate intermediate clock 2 on falling edge
            end
        end else begin
            cnt <= cnt + 1'b1; // Increment counter
            if (cnt == CYCLES_LOW) begin
                clk_div_int1 <= 1'b0; // Deassert intermediate clock 1
            end
            if (cnt == CYCLES_LOW + CYCLES_HIGH) begin
                clk_div_int2 <= 1'b0; // Deassert intermediate clock 2
            end
        end
        
        // Update previous clock value
        prev_clk <= clk;
    end
end

// Generate final fractional divided clock output by OR-ing intermediate clocks
assign clk_div = clk_div_int1 | clk_div_int2;

endmodule