module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division
parameter DIV_CLK_RATIO = 3.5;  // Fractional division ratio

// Internal signals
reg [2:0] cnt;  // Counter to track clock cycles
reg pwm_sig;  // PWM signal

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;  // Reset counter
    end else begin
        // Increment counter
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
        end else begin
            cnt <= cnt + 1'b1;
        end
    end
end

// Generate PWM signal
always @(*) begin
    // Determine threshold value based on fractional division ratio
    reg [2:0] threshold;
    threshold = MUL2_DIV_CLK * (DIV_CLK_RATIO - int(DIV_CLK_RATIO));
    
    // Compare counter value with threshold
    if (cnt < threshold) begin
        pwm_sig = 1'b1;  // PWM signal high
    end else begin
        pwm_sig = 1'b0;  // PWM signal low
    end
end

// Output logic
assign clk_div = pwm_sig;

endmodule