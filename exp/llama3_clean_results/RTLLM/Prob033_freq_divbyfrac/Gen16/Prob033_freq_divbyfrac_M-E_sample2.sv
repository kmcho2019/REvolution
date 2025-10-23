module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cnt;  // Counter to track clock cycles
reg pwm;        // PWM signal
reg prev_pwm;   // Previous PWM value

// Sequential logic for counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        pwm <= 1'b0;
        prev_pwm <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        prev_pwm <= pwm;
        
        // Update counter and PWM signal
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
        end else begin
            cnt <= cnt + 1'b1;
        end
        
        // Generate PWM signal
        if (cnt < 4) begin
            pwm <= 1'b1;
        end else begin
            pwm <= 1'b0;
        end
    end
end

// Combinational logic for final output
always @(*) begin
    // Generate final fractional divided clock output based on PWM signal
    if (pwm &&!prev_pwm) begin
        clk_div = 1'b1;
    end else if (!pwm && prev_pwm) begin
        clk_div = 1'b0;
    end else begin
        clk_div = clk_div;
    end
end

endmodule