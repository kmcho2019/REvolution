module freq_divbyfrac(
    input clk,      // Input clock signal
    input rst_n,     // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameter for the counter size (7 clock cycles)
localparam COUNTER_SIZE = 3;

// Counter for PWM
reg [COUNTER_SIZE-1:0] counter;

// Thresholds for 4-cycle and 3-cycle clock periods
localparam THRESHOLD_4CYC = 4'd3;  // 4/7 * (2^3 - 1)
localparam THRESHOLD_3CYC = 4'd2;  // 3/7 * (2^3 - 1)

// Output clock signal generation
reg clk_div_4cyc;
reg clk_div_3cyc;
reg clk_div_4cyc_phase_shifted;
reg clk_div_3cyc_phase_shifted;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= '0;
        clk_div <= 1'b0;
        clk_div_4cyc <= 1'b0;
        clk_div_3cyc <= 1'b0;
        clk_div_4cyc_phase_shifted <= 1'b0;
        clk_div_3cyc_phase_shifted <= 1'b0;
    end else begin
        // Increment counter and check against thresholds
        if (counter < (2**COUNTER_SIZE - 1)) begin
            counter <= counter + 1;
            if (counter <= THRESHOLD_4CYC) begin
                clk_div_4cyc <= 1'b1;
            end else begin
                clk_div_4cyc <= 1'b0;
            end
            if (counter <= THRESHOLD_3CYC) begin
                clk_div_3cyc <= 1'b1;
            end else begin
                clk_div_3cyc <= 1'b0;
            end
        end else begin
            counter <= '0;  // Reset counter
        end

        // Phase-shifting of divided clock signals
        if (clk_div_4cyc) begin
            clk_div_4cyc_phase_shifted <= 1'b1;
        end else begin
            clk_div_4cyc_phase_shifted <= 1'b0;
        end
        if (clk_div_3cyc) begin
            clk_div_3cyc_phase_shifted <= 1'b1;
        end else begin
            clk_div_3cyc_phase_shifted <= 1'b0;
        end

        // Logical OR of phase-shifted clock signals
        clk_div <= clk_div_4cyc_phase_shifted | clk_div_3cyc_phase_shifted;
    end
end

endmodule