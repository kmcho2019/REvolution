module freq_divbyfrac(
    input clk,      // Input clock signal
    input rst_n,     // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameter for the multiplier (3.5x division)
localparam MUL2_DIV_CLK = 7;

// Signals for digital frequency divider
reg [2:0] div_counter;  // Counter for digital frequency divider

// State machine for digital frequency divider
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        div_counter <= 3'd0;
    end else begin
        // Increment counter
        if (div_counter < MUL2_DIV_CLK - 1) begin
            div_counter <= div_counter + 1;
        end else begin
            div_counter <= 3'd0;
        end
    end
end

// Generate divided clock signals
wire div_clk_even;
wire div_clk_odd;
assign div_clk_even = (div_counter < 4)? 1'b1 : 1'b0;
assign div_clk_odd = (div_counter >= 4)? 1'b1 : 1'b0;

// Phase-shifting logic
wire div_clk_phase_shifted_even;
wire div_clk_phase_shifted_odd;
assign div_clk_phase_shifted_even = div_clk_even;
assign div_clk_phase_shifted_odd = div_clk_odd;

// Duty cycle imbalance correction
wire double_edge_clk;
assign double_edge_clk = (div_counter < 4)? 1'b1 : 1'b0;

// Logical OR-ing to produce the final fractional divided clock output
assign clk_div = (div_clk_phase_shifted_even | div_clk_phase_shifted_odd);

endmodule