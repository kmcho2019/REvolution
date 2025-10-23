module edge_detect (
    input  clk,    // Clock signal
    input  rst_n,   // Reset signal (active low)
    input  a,       // Input signal
    output rise,    // Output signal indicating a rising edge
    output down     // Output signal indicating a falling edge
);

reg prev_a;  // Register to store the previous state of "a"

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Reset condition
        prev_a <= 1'b0;  // Initialize previous state to 0
        rise <= 1'b0;    // Reset rise signal to 0
        down <= 1'b0;    // Reset down signal to 0
    end else begin
        prev_a <= a;  // Update previous state on each clock cycle
        if (a &&!prev_a) begin  // Rising edge detected
            rise <= 1'b1;  // Set rise signal to 1
            down <= 1'b0;  // Set down signal to 0
        end else if (!a && prev_a) begin  // Falling edge detected
            down <= 1'b1;  // Set down signal to 1
            rise <= 1'b0;  // Set rise signal to 0
        end else begin  // No edge detected
            rise <= 1'b0;  // Set rise signal to 0
            down <= 1'b0;  // Set down signal to 0
        end
    end
end

endmodule