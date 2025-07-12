module edge_detect(
    input clk,         // Clock signal
    input rst_n,       // Reset signal (active low)
    input a,          // Input signal
    output reg rise,  // Output signal indicating a rising edge
    output reg down   // Output signal indicating a falling edge
);

reg prev_a;  // Previous value of the input signal "a"

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Reset
        prev_a <= 1'b0;  // Initialize previous value to 0
        rise <= 1'b0;   // Reset rise signal
        down <= 1'b0;  // Reset down signal
    end else begin
        prev_a <= a;  // Store current value as previous value
        if (a && !prev_a) begin  // Rising edge detected
            rise <= 1'b1;  // Set rise signal to 1
            down <= 1'b0; // Reset down signal
        end else if (!a && prev_a) begin  // Falling edge detected
            rise <= 1'b0;  // Reset rise signal
            down <= 1'b1; // Set down signal to 1
        end else begin  // No edge detected
            rise <= 1'b0;  // Reset rise signal
            down <= 1'b0; // Reset down signal
        end
    end
end

endmodule