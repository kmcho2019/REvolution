module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cnt;  // Counter to track clock cycles
reg [7:0] phase_accum;  // Phase accumulator
reg [7:0] phase_error;  // Phase error signal
reg [7:0] loop_filter_out;  // Loop filter output
reg clk_div_int;  // Intermediate divided clock
reg clk_div_phase_shifted;  // Phase-shifted divided clock

// Sequential logic for counter and phase accumulator
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        phase_accum <= 8'b00000000;
        phase_error <= 8'b00000000;
        loop_filter_out <= 8'b00000000;
        clk_div_int <= 1'b0;
        clk_div_phase_shifted <= 1'b0;
    end else begin
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
        end else begin
            cnt <= cnt + 1'b1;
        end
        phase_accum <= phase_accum + (cnt == 3 || cnt == 6) ? 8'b00010000 : 8'b00000000;
        phase_error <= phase_accum - loop_filter_out;
        loop_filter_out <= (phase_error + loop_filter_out) / 2;
        clk_div_int <= (cnt == 3 || cnt == 6) ? 1'b1 : 1'b0;
        clk_div_phase_shifted <= (phase_accum[7] == 1'b1) ? 1'b1 : 1'b0;
    end
end

// Combinational logic for final fractional divided clock output
assign clk_div = clk_div_int || clk_div_phase_shifted;

endmodule