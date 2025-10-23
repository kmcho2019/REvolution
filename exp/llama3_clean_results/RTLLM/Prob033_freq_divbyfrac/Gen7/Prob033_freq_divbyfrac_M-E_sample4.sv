module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cnt;  // Counter to track clock cycles
reg [2:0] phase_cnt;  // Counter for phase interpolator
reg phase_clk;  // Phase interpolated clock signal
reg pwm_clk;  // PWM clock signal
reg clk_div_int;  // Intermediate divided clock signal

// Phase interpolator logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        phase_cnt <= 3'b000;  // Reset phase interpolator counter
        phase_clk <= 1'b0;  // Reset phase interpolated clock
    end else begin
        // Increment phase interpolator counter
        if (phase_cnt == MUL2_DIV_CLK - 1) begin
            phase_cnt <= 3'b000;
        end else begin
            phase_cnt <= phase_cnt + 1'b1;
        end

        // Generate phase interpolated clock signal
        if (phase_cnt < 4) begin
            phase_clk <= 1'b1;  // 4 cycles clock
        end else begin
            phase_clk <= 1'b0;
        end
    end
end

// PWM logic
always @(posedge phase_clk or negedge rst_n) begin
    if (~rst_n) begin
        pwm_clk <= 1'b0;  // Reset PWM clock
    end else begin
        // Generate PWM clock signal
        if (phase_cnt < 3) begin
            pwm_clk <= 1'b1;  // 3 cycles clock
        end else begin
            pwm_clk <= 1'b0;
        end
    end
end

// Intermediate divided clock logic
always @(posedge pwm_clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_int <= 1'b0;  // Reset intermediate divided clock
    end else begin
        // Generate intermediate divided clock signal
        if (pwm_clk) begin
            clk_div_int <= 1'b1;
        end else begin
            clk_div_int <= 1'b0;
        end
    end
end

// Final divided clock logic
always @(posedge clk_div_int or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0;  // Reset final divided clock
    end else begin
        // Generate final divided clock signal
        if (clk_div_int) begin
            clk_div <= 1'b1;
        end else begin
            clk_div <= 1'b0;
        end
    end
end

endmodule