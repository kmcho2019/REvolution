module freq_divbyfrac(
    input clk,      // Input clock signal
    input rst_n,     // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameter for the multiplier (3.5x division)
localparam MUL2_DIV_CLK = 7;

// Signals for digital frequency divider
reg [2:0] div_counter;  // Counter for digital frequency divider
reg div_clk_even;       // Even clock signal from digital frequency divider
reg div_clk_odd;        // Odd clock signal from digital frequency divider
reg div_clk_phase_shifted_even;  // Phase-shifted even clock signal
reg div_clk_phase_shifted_odd;   // Phase-shifted odd clock signal

// State machine for digital frequency divider
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        div_counter <= 3'd0;
        div_clk_even <= 1'b0;
        div_clk_odd <= 1'b0;
    end else begin
        // 3.5x frequency division using digital frequency divider
        if (div_counter < 3'd4) begin
            div_counter <= div_counter + 1;
            div_clk_even <= 1'b1;
            div_clk_odd <= 1'b0;
        end else if (div_counter < 3'd7) begin
            div_counter <= div_counter + 1;
            div_clk_even <= 1'b0;
            div_clk_odd <= 1'b1;
        end else begin
            div_counter <= 3'd0;
            div_clk_even <= 1'b0;
            div_clk_odd <= 1'b0;
        end
    end
end

// Phase-shifting logic
reg clk_phase_shift_buf;
always @(posedge clk) begin
    clk_phase_shift_buf <= clk;
end
assign div_clk_phase_shifted_even = div_clk_even && clk;
assign div_clk_phase_shifted_odd = div_clk_odd && ~clk_phase_shift_buf;

// Logical OR-ing to produce the final fractional divided clock output
assign clk_div = div_clk_phase_shifted_even | div_clk_phase_shifted_odd;

endmodule