module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters
parameter MUL2_DIV_CLK = 7; // Total clock cycles for 3.5x division
parameter DIV_CLK_1 = 4; // First uneven clock period
parameter DIV_CLK_2 = 3; // Second uneven clock period

// Internal signals
reg [2:0] counter; // Counter to cycle through clock cycles
reg clk_int_1; // First intermediate divided clock
reg clk_int_2; // Second intermediate divided clock
reg clk_int_1_phase_shifted; // Phase-shifted version of first intermediate clock
reg clk_int_2_phase_shifted; // Phase-shifted version of second intermediate clock

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000;
        clk_int_1 <= 1'b0;
        clk_int_2 <= 1'b0;
        clk_int_1_phase_shifted <= 1'b0;
        clk_int_2_phase_shifted <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b000;
        end else begin
            counter <= counter + 1'b1;
        end

        // Generate first intermediate divided clock
        if (counter < DIV_CLK_1) begin
            clk_int_1 <= 1'b1;
        end else begin
            clk_int_1 <= 1'b0;
        end

        // Generate second intermediate divided clock
        if (counter >= DIV_CLK_1 && counter < DIV_CLK_1 + DIV_CLK_2) begin
            clk_int_2 <= 1'b1;
        end else begin
            clk_int_2 <= 1'b0;
        end

        // Generate phase-shifted versions of intermediate clocks
        if (counter == DIV_CLK_1 - 1) begin
            clk_int_1_phase_shifted <= 1'b1;
        end else if (counter == MUL2_DIV_CLK - 1) begin
            clk_int_1_phase_shifted <= 1'b0;
        end else begin
            clk_int_1_phase_shifted <= clk_int_1_phase_shifted;
        end

        if (counter == DIV_CLK_1 + DIV_CLK_2 - 1) begin
            clk_int_2_phase_shifted <= 1'b1;
        end else if (counter == MUL2_DIV_CLK - 1) begin
            clk_int_2_phase_shifted <= 1'b0;
        end else begin
            clk_int_2_phase_shifted <= clk_int_2_phase_shifted;
        end

        // Generate final fractional divided clock output
        clk_div <= clk_int_1 | clk_int_2 | clk_int_1_phase_shifted | clk_int_2_phase_shifted;
    end
end

endmodule