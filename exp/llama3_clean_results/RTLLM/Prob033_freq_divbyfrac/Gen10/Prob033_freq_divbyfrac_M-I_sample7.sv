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

// Digital frequency divider implementation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        div_counter <= 3'd0;
        div_clk_even <= 1'b0;
        div_clk_odd <= 1'b0;
    end else begin
        // 3.5x frequency division using digital frequency divider
        case (div_counter)
            3'd0, 3'd1, 3'd2, 3'd3: begin
                div_counter <= div_counter + 1;
                div_clk_even <= 1'b1;
            end
            3'd4, 3'd5, 3'd6: begin
                div_counter <= div_counter + 1;
                div_clk_odd <= 1'b1;
            end
            default: begin
                div_counter <= 3'd0;
                div_clk_even <= 1'b0;
                div_clk_odd <= 1'b0;
            end
        endcase
    end
end

// Phase-shifting and logical OR-ing
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        div_clk_phase_shifted_even <= 1'b0;
        div_clk_phase_shifted_odd <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        // Phase-shifted clock signals
        div_clk_phase_shifted_even <= div_clk_even;
        div_clk_phase_shifted_odd <= div_clk_odd;
        
        // Logical OR-ing to produce the final fractional divided clock output
        clk_div <= div_clk_phase_shifted_even | div_clk_phase_shifted_odd;
    end
end

endmodule