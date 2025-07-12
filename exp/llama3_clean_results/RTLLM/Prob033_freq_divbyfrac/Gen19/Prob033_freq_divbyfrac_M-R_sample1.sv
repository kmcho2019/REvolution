module freq_divbyfrac(
    input clk,      // Input clock signal
    input rst_n,     // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameter for the multiplier (3.5x division)
localparam MUL2_DIV_CLK = 7;

// Signals for counter
reg [2:0] counter;  // Current counter value

// Signals for PWM signal generation
reg pwm_signal;        // PWM signal

// Counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'd0;  // Initialize counter to 0
    end else begin
        // Update counter value based on current counter value
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'd0;
        end else begin
            counter <= counter + 1'b1;
        end
    end
end

// PWM signal generation
assign pwm_signal = (counter < 4)? 1'b1 : 1'b0;

// Clock signal generation
assign clk_div = pwm_signal;

endmodule