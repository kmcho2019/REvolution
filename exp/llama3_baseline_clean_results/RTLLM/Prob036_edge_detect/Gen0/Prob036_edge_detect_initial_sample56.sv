module edge_detect (
    input  clk,    // Clock signal
    input  rst_n,  // Reset signal (active low)
    input  a,      // Input signal
    output rise,   // Output signal indicating a rising edge
    output down    // Output signal indicating a falling edge
);

reg prev_a;  // Register to store the previous value of 'a'

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Reset
        prev_a <= 1'b0;  // Initialize previous value of 'a' to 0
        rise <= 1'b0;    // Reset rise output signal
        down <= 1'b0;    // Reset down output signal
    end else begin
        prev_a <= a;     // Store the current value of 'a' for the next cycle
        if (a && !prev_a) begin  // Rising edge detected
            rise <= 1'b1;  // Set rise output signal
            down <= 1'b0;  // Reset down output signal
        end else if (!a && prev_a) begin  // Falling edge detected
            rise <= 1'b0;  // Reset rise output signal
            down <= 1'b1;  // Set down output signal
        end else begin  // No edge detected
            rise <= 1'b0;  // Reset rise output signal
            down <= 1'b0;  // Reset down output signal
        end
    end
end

endmodule