module freq_divbyfrac (
    input clk,
    input rst_n,
    output reg clk_div
);

// Define constants for the fractional division
localparam MUL2_DIV_CLK = 7; // For 3.5x division, 7 clock cycles

// Counter to cycle through the clock divisions
reg [2:0] counter;

// Internal signals for the divided clocks
reg clk_div_4, clk_div_3;

// Phase-shifted versions of the divided clocks
reg clk_div_4_delayed, clk_div_3_advanced;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter and internal signals
        counter <= 3'b0;
        clk_div_4 <= 1'b0;
        clk_div_3 <= 1'b0;
        clk_div_4_delayed <= 1'b0;
        clk_div_3_advanced <= 1'b0;
    end else begin
        // Count up to MUL2_DIV_CLK
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b0;
        end else begin
            counter <= counter + 1'b1;
        end

        // Generate divided clocks based on the counter value
        if (counter == 3'b100) begin // 4th cycle
            clk_div_4 <= 1'b1;
        end else if (counter == 3'b000) begin // Reset after 4th cycle
            clk_div_4 <= 1'b0;
        end

        if (counter == 3'b011) begin // 3rd cycle
            clk_div_3 <= 1'b1;
        end else if (counter == 3'b100) begin // Reset after 3rd cycle
            clk_div_3 <= 1'b0;
        end

        // Generate phase-shifted versions of the divided clocks
        // Delay clk_div_4 by half a clock period
        if (counter == 3'b101) begin // Half clock period after 4th cycle
            clk_div_4_delayed <= clk_div_4;
        end else begin
            clk_div_4_delayed <= 1'b0;
        end

        // Advance clk_div_3 by half a clock period
        if (counter == 3'b010) begin // Half clock period before 3rd cycle
            clk_div_3_advanced <= 1'b1;
        end else if (counter == 3'b011) begin // Reset after advancement
            clk_div_3_advanced <= 1'b0;
        end
    end
end

// Logically OR the phase-shifted clocks to produce the final output
always @(posedge clk) begin
    clk_div <= clk_div_4_delayed | clk_div_3_advanced;
end

endmodule