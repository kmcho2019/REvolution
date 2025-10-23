module freq_divbyfrac (
    input clk,    // Input clock signal
    input rst_n,  // Active low reset signal
    output clk_div // Fractionally divided clock output
);

parameter MUL2_DIV_CLK = 7; // Cycle through 7 clock cycles for 3.5x division
parameter CLK_HALF_PERIOD = 1; // Half of the clock period

reg [2:0] counter; // Counter to cycle through 7 clock cycles
reg clk_phase_a; // First phase of the divided clock
reg clk_phase_b; // Second phase of the divided clock
reg clk_phase_a_delayed; // Delayed version of the first phase
reg clk_phase_b_advanced; // Advanced version of the second phase

// Count clock cycles to achieve the division factor
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b000;
        clk_phase_a <= 1'b0;
        clk_phase_b <= 1'b0;
        clk_phase_a_delayed <= 1'b0;
        clk_phase_b_advanced <= 1'b0;
    end else begin
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b000;
        end else begin
            counter <= counter + 1'b1;
        end

        // Generate two uneven clock periods
        if (counter < 4) begin
            clk_phase_a <= 1'b1;
        end else begin
            clk_phase_a <= 1'b0;
        end

        if (counter >= 4) begin
            clk_phase_b <= 1'b1;
        end else begin
            clk_phase_b <= 1'b0;
        end

        // Generate phase-shifted versions of the divided clocks
        if (counter == 0) begin
            clk_phase_a_delayed <= 1'b1;
        end else if (counter == 3) begin
            clk_phase_a_delayed <= 1'b0;
        end

        if (counter == 4) begin
            clk_phase_b_advanced <= 1'b1;
        end else if (counter == 7 - 1) begin
            clk_phase_b_advanced <= 1'b0;
        end
    end
end

// Logically OR the two phase-shifted clocks to produce the final fractional divided clock output
assign clk_div = (clk_phase_a && !clk_phase_a_delayed) || (clk_phase_b && !clk_phase_b_advanced);

endmodule