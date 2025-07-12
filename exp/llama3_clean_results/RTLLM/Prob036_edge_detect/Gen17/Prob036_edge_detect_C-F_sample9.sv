module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output reg    rise,     // Output signal indicating a rising edge
    output reg    down      // Output signal indicating a falling edge
);

reg prev_a;  // Register to store the previous state of 'a'

// Sequential logic to store the previous state of 'a'
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the module to a known state
        prev_a <= 1'b0;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        // Store the current state of 'a' in the previous state register
        prev_a <= a;
    end
end

// Combinational logic for edge detection
wire edge_detected = a ^ prev_a;

always @(posedge clk) begin
    if (edge_detected) begin
        if (a) begin
            // Rising edge detected
            rise <= 1'b1;
            down <= 1'b0;
        end else begin
            // Falling edge detected
            rise <= 1'b0;
            down <= 1'b1;
        end
    end else begin
        // No edge detected, reset outputs
        rise <= 1'b0;
        down <= 1'b0;
    end
end

endmodule