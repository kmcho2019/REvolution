module edge_detect (
    input clk,      // Clock signal
    input rst_n,    // Reset signal (active low)
    input a,        // Input signal
    output rise,    // Output signal indicating a rising edge
    output down     // Output signal indicating a falling edge
);

reg prev_a;         // Register to store the previous value of "a"

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        prev_a <= 1'b0;  // Reset previous value of "a"
        rise <= 1'b0;    // Reset rise signal
        down <= 1'b0;    // Reset down signal
    end else begin
        if (a && !prev_a) begin
            // Rising edge detected, set rise to 1 and down to 0
            rise <= 1'b1;
            down <= 1'b0;
        end else if (!a && prev_a) begin
            // Falling edge detected, set down to 1 and rise to 0
            rise <= 1'b0;
            down <= 1'b1;
        end else begin
            // No edge detected, set both signals to 0
            rise <= 1'b0;
            down <= 1'b0;
        end
        prev_a <= a;  // Update previous value of "a"
    end
end

endmodule