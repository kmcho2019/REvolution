module freq_divbyfrac(
    input clk,      // Input clock signal
    input rst_n,     // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for the fractional frequency divider
localparam PWM_WIDTH = 7;  // Width of the PWM signal
localparam FILTER_ORDER = 3;  // Order of the digital filter
localparam PHASE_SHIFT = 1;  // Phase shift value

// Signals for the PWM generator
reg [PWM_WIDTH-1:0] pwm_cnt;  // Counter for PWM signal generation
reg pwm_signal;  // PWM signal

// Signals for the digital filter
reg [FILTER_ORDER-1:0] filter_tap;  // Filter tap signals
reg [FILTER_ORDER-1:0] filter_coeff;  // Filter coefficients
reg filtered_signal;  // Filtered signal

// Signals for the zero-crossing detector
reg zc_detected;  // Zero-crossing detection flag
reg zc_clk;  // Zero-crossing clock signal

// Signals for the phase-shifting logic
reg phase_shifted_clk;  // Phase-shifted clock signal

// Initialize the PWM generator
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        pwm_cnt <= 0;
        pwm_signal <= 0;
    end else begin
        if (pwm_cnt < PWM_WIDTH) begin
            pwm_cnt <= pwm_cnt + 1;
            if (pwm_cnt < 4) begin
                pwm_signal <= 1;
            end else begin
                pwm_signal <= 0;
            end
        end else begin
            pwm_cnt <= 0;
        end
    end
end

// Implement the digital filter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        filter_tap <= 0;
        filtered_signal <= 0;
    end else begin
        filter_tap <= {filter_tap[FILTER_ORDER-2:0], pwm_signal};
        filtered_signal <= (filter_tap[0] + filter_tap[1] + filter_tap[2]) > 1;
    end
end

// Implement the zero-crossing detector
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        zc_detected <= 0;
        zc_clk <= 0;
    end else begin
        if (filtered_signal && ~zc_detected) begin
            zc_detected <= 1;
            zc_clk <= 1;
        end else if (~filtered_signal && zc_detected) begin
            zc_detected <= 0;
            zc_clk <= 0;
        end
    end
end

// Implement the phase-shifting logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        phase_shifted_clk <= 0;
    end else begin
        phase_shifted_clk <= zc_clk;
        #PHASE_SHIFT;
        phase_shifted_clk <= ~zc_clk;
    end
end

// Generate the divided clock signal
assign clk_div = phase_shifted_clk;

endmodule