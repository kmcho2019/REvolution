module freq_divbyfrac(
    input clk,      // Input clock signal
    input rst_n,     // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for the fractional frequency division
localparam DIV_4 = 4;  // Counter limit for 4 clock cycles
localparam DIV_3 = 3;  // Counter limit for 3 clock cycles

// Signals for the dual-counter structure
reg [1:0] counter_4;  // Counter for 4 clock cycles
reg [1:0] counter_3;  // Counter for 3 clock cycles
reg pll_lock;         // Phase-locking signal

// State machine for the counters and phase-locking
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter_4 <= 2'd0;
        counter_3 <= 2'd0;
        pll_lock <= 1'b0;
    end else begin
        // Increment counter_4
        if (counter_4 < DIV_4 - 1) begin
            counter_4 <= counter_4 + 1;
        end else begin
            counter_4 <= 2'd0;
            pll_lock <= ~pll_lock;
        end

        // Increment counter_3
        if (pll_lock) begin
            if (counter_3 < DIV_3 - 1) begin
                counter_3 <= counter_3 + 1;
            end else begin
                counter_3 <= 2'd0;
            end
        end
    end
end

// Clock generation for the divided clock signals
reg clk_div_4;  // Divided clock signal for 4 clock cycles
reg clk_div_3;  // Divided clock signal for 3 clock cycles
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_4 <= 1'b0;
        clk_div_3 <= 1'b0;
    end else begin
        // Generate clk_div_4
        if (counter_4 == 2'd0) begin
            clk_div_4 <= 1'b1;
        end else begin
            clk_div_4 <= 1'b0;
        end

        // Generate clk_div_3
        if (pll_lock && counter_3 == 2'd0) begin
            clk_div_3 <= 1'b1;
        end else begin
            clk_div_3 <= 1'b0;
        end
    end
end

// Phase-shifting and logical OR-ing to produce the final fractional divided clock output
reg clk_div_4_phase_shifted;  // Phase-shifted divided clock signal for 4 clock cycles
reg clk_div_3_phase_shifted;  // Phase-shifted divided clock signal for 3 clock cycles
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_4_phase_shifted <= 1'b0;
        clk_div_3_phase_shifted <= 1'b0;
    end else begin
        // Phase-shift clk_div_4
        if (counter_4 == 2'd1) begin
            clk_div_4_phase_shifted <= 1'b1;
        end else begin
            clk_div_4_phase_shifted <= 1'b0;
        end

        // Phase-shift clk_div_3
        if (pll_lock && counter_3 == 2'd1) begin
            clk_div_3_phase_shifted <= 1'b1;
        end else begin
            clk_div_3_phase_shifted <= 1'b0;
        end
    end
end

assign clk_div = clk_div_4_phase_shifted | clk_div_3_phase_shifted;

endmodule