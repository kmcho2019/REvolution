module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters for fractional division
parameter MUL2_DIV_CLK = 7; // Total clock cycles for 3.5x division
parameter NUM_CLK-high = 4; // Number of clock cycles for high phase
parameter NUM_CLK-low = 3;  // Number of clock cycles for low phase

// Internal signals
reg [2:0] count; // Counter to keep track of clock cycles
reg clk_div_high; // High phase divided clock
reg clk_div_low;  // Low phase divided clock
reg prev_clk;     // Previous clock value for edge detection

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset all internal signals
        count <= 3'b0;
        clk_div_high <= 1'b0;
        clk_div_low <= 1'b0;
        prev_clk <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        // Increment counter
        count <= count + 1;

        // Generate high phase divided clock
        if (count == 3'b100) begin // 4 clock cycles
            clk_div_high <= 1'b1;
        end else if (count == 3'b111) begin // Reset high phase
            clk_div_high <= 1'b0;
        end

        // Generate low phase divided clock (delayed by half a clock period)
        if (prev_clk == 1'b1 && clk == 1'b0) begin // Falling edge detection
            if (count == 3'b011) begin // 3 clock cycles
                clk_div_low <= 1'b1;
            end else if (count == 3'b101) begin // Reset low phase
                clk_div_low <= 1'b0;
            end
        end

        // Generate final fractional divided clock output
        clk_div <= clk_div_high | clk_div_low;

        // Update previous clock value
        prev_clk <= clk;

        // Reset counter
        if (count == MUL2_DIV_CLK - 1) begin
            count <= 3'b0;
        end
    end
end

endmodule