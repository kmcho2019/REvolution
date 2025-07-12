module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

// Generate a PWM signal based on valid_count to control the counter
logic pwm_signal;
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pwm_signal <= 1'b0;
    end else if (valid_count) begin
        pwm_signal <= ~pwm_signal;
    end
end

// Use the PWM signal to control the counter increment
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end else if (pwm_signal && out < 4'd11) begin
        out <= out + 1;
    end else if (pwm_signal && out == 4'd11) begin
        out <= 4'b0000;
    end
end

endmodule