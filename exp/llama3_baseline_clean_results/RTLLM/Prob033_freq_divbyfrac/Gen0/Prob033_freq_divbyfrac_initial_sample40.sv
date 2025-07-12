module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

parameter MUL2_DIV_CLK = 7; // Dividing factor for fractional division

reg [2:0] counter; // Counter to keep track of clock cycles
reg prev_clk; // Previous clock value to detect rising edge
reg clk_div_1; // First divided clock with 4 source clock cycles
reg clk_div_2; // Second divided clock with 3 source clock cycles
reg delayed_clk; // Delayed version of the first divided clock
reg advanced_clk; // Advanced version of the second divided clock

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'd0; // Reset counter
        prev_clk <= 1'b0; // Reset previous clock value
        clk_div_1 <= 1'b0; // Reset first divided clock
        clk_div_2 <= 1'b0; // Reset second divided clock
        delayed_clk <= 1'b0; // Reset delayed clock
        advanced_clk <= 1'b0; // Reset advanced clock
    end else begin
        prev_clk <= clk; // Update previous clock value

        // Increment counter on rising edge of clock
        if (clk && !prev_clk) begin
            if (counter == MUL2_DIV_CLK - 1) begin
                counter <= 3'd0; // Reset counter
            end else begin
                counter <= counter + 1; // Increment counter
            end
        end

        // Generate divided clocks based on counter value
        if (counter < 3'd4) begin
            clk_div_1 <= (counter == 3'd3); // First divided clock
        end else begin
            clk_div_1 <= 1'b0;
        end

        if (counter >= 3'd4) begin
            clk_div_2 <= (counter == 3'd6); // Second divided clock
        end else begin
            clk_div_2 <= 1'b0;
        end

        // Generate phase-shifted versions of divided clocks
        delayed_clk <= (clk_div_1 && !prev_clk); // Delayed version of first divided clock
        advanced_clk <= (clk_div_2 && prev_clk); // Advanced version of second divided clock

        // Logically OR phase-shifted clocks to produce final output
        clk_div <= (delayed_clk || advanced_clk); // Final fractional divided clock output
    end
end

endmodule