module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output reg    rise,     // Output signal indicating a rising edge
    output reg    down      // Output signal indicating a falling edge
);

reg prev_a;  // Register to store the previous value of 'a'
reg curr_a;  // Register to store the current value of 'a'

// Sequential logic to store the previous and current values of 'a'
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the module to a known state
        prev_a <= 1'b0;
        curr_a <= 1'b0;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        // Shift the current value of 'a' into the previous value register
        prev_a <= curr_a;
        // Update the current value register with the new value of 'a'
        curr_a <= a;
    end
end

// Combinational logic to detect rising and falling edges
always @(*) begin
    if (curr_a && !prev_a) begin
        // Rising edge detected
        rise = 1'b1;
        down = 1'b0;
    end else if (!curr_a && prev_a) begin
        // Falling edge detected
        rise = 1'b0;
        down = 1'b1;
    end else begin
        // No edge detected
        rise = 1'b0;
        down = 1'b0;
    end
end

endmodule