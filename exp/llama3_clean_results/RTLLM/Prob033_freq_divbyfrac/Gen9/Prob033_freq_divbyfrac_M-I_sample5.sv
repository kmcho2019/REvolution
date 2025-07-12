module freq_divbyfrac(
    input clk,      // Input clock signal
    input rst_n,     // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameter for the multiplier (3.5x division)
localparam MUL2_DIV_CLK = 7;

// Signals for duty cycle controller
reg [2:0] duty_cycle;
reg [2:0] next_duty_cycle;

// Signals for PWM generator
reg [2:0] pwm_counter;
reg pwm_signal;

// Signals for clock output generator
reg clk_div_dly;
reg clk_div_adv;
reg clk_div_d;

// Duty cycle controller
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        duty_cycle <= 3'd4;  // Initialize duty cycle to 4/7
    end else begin
        // Update duty cycle based on division ratio
        if (duty_cycle == 3'd4) begin
            next_duty_cycle <= 3'd3;
        end else if (duty_cycle == 3'd3) begin
            next_duty_cycle <= 3'd4;
        end
        duty_cycle <= next_duty_cycle;
    end
end

// PWM generator
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        pwm_counter <= 3'd0;
        pwm_signal <= 1'b0;
    end else begin
        // Generate PWM signal based on duty cycle
        if (pwm_counter < duty_cycle) begin
            pwm_signal <= 1'b1;
        end else begin
            pwm_signal <= 1'b0;
        end
        // Update PWM counter
        if (pwm_counter == MUL2_DIV_CLK - 1) begin
            pwm_counter <= 3'd0;
        end else begin
            pwm_counter <= pwm_counter + 1;
        end
    end
end

// Clock output generator
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_dly <= 1'b0;
        clk_div_adv <= 1'b0;
        clk_div_d <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        // Generate phase-shifted clock signals
        clk_div_dly <= pwm_signal;
        clk_div_adv <= ~pwm_signal;
        // Generate final fractional clock output
        if (pwm_signal) begin
            clk_div_d <= 1'b1;
        end else begin
            clk_div_d <= 1'b0;
        end
        // Final clock output
        if (clk_div_dly || clk_div_adv) begin
            clk_div <= clk_div_d;
        end else begin
            clk_div <= 1'b0;
        end
    end
end

endmodule