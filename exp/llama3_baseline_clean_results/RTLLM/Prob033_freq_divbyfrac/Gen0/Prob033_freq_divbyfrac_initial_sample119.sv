module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters for frequency division
parameter MUL2_DIV_CLK = 7; // Total clock cycles for 3.5x division
parameter DIV_CLK_CYCLES_HIGH = 4; // Clock cycles for high phase
parameter DIV_CLK_CYCLES_LOW = 3; // Clock cycles for low phase

// Counter to track clock cycles
reg [2:0] counter;

// Signals for intermediate divided clocks
reg clk_div_high;
reg clk_div_low;
reg clk_div_high_phase_shifted;
reg clk_div_low_phase_shifted;

// Reset logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b0;
        clk_div_high <= 1'b0;
        clk_div_low <= 1'b0;
        clk_div_high_phase_shifted <= 1'b0;
        clk_div_low_phase_shifted <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        // Counter logic
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b0;
        end else begin
            counter <= counter + 1;
        end

        // Generate intermediate divided clocks
        if (counter < DIV_CLK_CYCLES_HIGH) begin
            clk_div_high <= 1'b1;
        end else begin
            clk_div_high <= 1'b0;
        end

        if ((counter >= DIV_CLK_CYCLES_HIGH) && (counter < MUL2_DIV_CLK)) begin
            clk_div_low <= 1'b1;
        end else begin
            clk_div_low <= 1'b0;
        end

        // Phase-shift intermediate clocks
        if (counter == DIV_CLK_CYCLES_HIGH - 1) begin
            clk_div_high_phase_shifted <= 1'b1;
        end else if (counter == MUL2_DIV_CLK - 1) begin
            clk_div_high_phase_shifted <= 1'b0;
        end else begin
            clk_div_high_phase_shifted <= clk_div_high_phase_shifted;
        end

        if (counter == DIV_CLK_CYCLES_HIGH) begin
            clk_div_low_phase_shifted <= 1'b1;
        end else if (counter == MUL2_DIV_CLK - 1) begin
            clk_div_low_phase_shifted <= 1'b0;
        end else begin
            clk_div_low_phase_shifted <= clk_div_low_phase_shifted;
        end

        // Generate final divided clock
        clk_div <= clk_div_high | clk_div_low | clk_div_high_phase_shifted | clk_div_low_phase_shifted;
    end
end

endmodule