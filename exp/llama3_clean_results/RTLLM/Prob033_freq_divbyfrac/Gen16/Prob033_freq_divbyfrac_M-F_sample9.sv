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

// State machine for digital frequency divider
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        div_counter <= 3'd0;
        div_clk_even <= 1'b0;
        div_clk_odd <= 1'b0;
    end else begin
        // Increment counter
        if (div_counter < MUL2_DIV_CLK - 1) begin
            div_counter <= div_counter + 1;
        end else begin
            div_counter <= 3'd0;
        end

        // Generate divided clock signals
        if (div_counter < 4) begin
            div_clk_even <= 1'b1;
        end else begin
            div_clk_even <= 1'b0;
        end

        if (div_counter >= 4) begin
            div_clk_odd <= 1'b1;
        end else begin
            div_clk_odd <= 1'b0;
        end
    end
end

// Phase-shifting logic
reg [1:0] phase_shift_counter;
always @(posedge clk) begin
    if (~rst_n) begin
        phase_shift_counter <= 2'd0;
    end else if (div_clk_even) begin
        phase_shift_counter <= 2'd1;
    end else if (div_clk_odd) begin
        phase_shift_counter <= 2'd2;
    end else begin
        phase_shift_counter <= 2'd0;
    end
end

reg div_clk_phase_shifted_even;
reg div_clk_phase_shifted_odd;
always @(posedge clk) begin
    if (~rst_n) begin
        div_clk_phase_shifted_even <= 1'b0;
        div_clk_phase_shifted_odd <= 1'b0;
    end else begin
        if (phase_shift_counter == 2'd1) begin
            div_clk_phase_shifted_even <= 1'b1;
        end else begin
            div_clk_phase_shifted_even <= 1'b0;
        end

        if (phase_shift_counter == 2'd2) begin
            div_clk_phase_shifted_odd <= 1'b1;
        end else begin
            div_clk_phase_shifted_odd <= 1'b0;
        end
    end
end

// Logical OR-ing to produce the final fractional divided clock output
assign clk_div = div_clk_phase_shifted_even | div_clk_phase_shifted_odd;

endmodule