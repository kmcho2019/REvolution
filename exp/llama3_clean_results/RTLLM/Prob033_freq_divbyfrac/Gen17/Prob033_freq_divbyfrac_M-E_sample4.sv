module freq_divbyfrac(
    input clk,      // Input clock signal
    input rst_n,     // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameter for the multiplier (3.5x division)
localparam MUL2_DIV_CLK = 7;

// Signals for fractional division ratio calculation
reg [2:0] duty_cycle;  // Duty cycle value for PWM signal

// Signals for PWM signal generation
reg [2:0] pwm_counter;  // Counter for PWM signal generation
reg pwm_signal;        // PWM signal

// Signals for clock signal generation
reg clk_enable;        // Enable signal for clock signal generation

// Fractional division ratio calculation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        duty_cycle <= 3'd4;  // Initialize duty cycle value
    end else begin
        // Calculate duty cycle value based on fractional division ratio
        duty_cycle <= 3'd4;  // 4/7 duty cycle for 3.5x division
    end
end

// PWM signal generation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        pwm_counter <= 3'd0;  // Initialize PWM counter
        pwm_signal <= 1'b0;  // Initialize PWM signal
    end else begin
        // Increment PWM counter
        if (pwm_counter < MUL2_DIV_CLK - 1) begin
            pwm_counter <= pwm_counter + 1;
        end else begin
            pwm_counter <= 3'd0;
        end

        // Generate PWM signal
        if (pwm_counter < duty_cycle) begin
            pwm_signal <= 1'b1;
        end else begin
            pwm_signal <= 1'b0;
        end
    end
end

// Clock signal generation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_enable <= 1'b0;  // Initialize clock enable signal
        clk_div <= 1'b0;     // Initialize clock output
    end else begin
        // Generate clock output based on PWM signal
        if (pwm_signal) begin
            clk_enable <= 1'b1;
        end else begin
            clk_enable <= 1'b0;
        end

        // Clock output
        if (clk_enable) begin
            clk_div <= clk;
        end else begin
            clk_div <= 1'b0;
        end
    end
end

endmodule