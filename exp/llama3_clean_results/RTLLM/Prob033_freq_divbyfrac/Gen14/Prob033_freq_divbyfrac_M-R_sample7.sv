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
            div_clk_odd <= 1'b0;
        end else begin
            div_clk_even <= 1'b0;
            div_clk_odd <= 1'b1;
        end
    end
end

// Phase-shifting logic
reg clk_phase_shift_buf;
always @(posedge clk) begin
    clk_phase_shift_buf <= clk;
end
wire div_clk_phase_shifted_even = div_clk_even && clk;
wire div_clk_phase_shifted_odd = div_clk_odd && ~clk;

// Duty cycle imbalance correction using double-edge clocking
reg double_edge_clk;
always @(posedge clk or posedge ~clk) begin
    double_edge_clk <= ~double_edge_clk;
end

// Logical OR-ing to produce the final fractional divided clock output
assign clk_div = (div_clk_phase_shifted_even | div_clk_phase_shifted_odd) && double_edge_clk;

endmodule