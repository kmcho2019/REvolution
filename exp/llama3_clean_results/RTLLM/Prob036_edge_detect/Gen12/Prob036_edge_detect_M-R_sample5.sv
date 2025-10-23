module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output        rise,     // Output signal indicating a rising edge
    output        down      // Output signal indicating a falling edge
);

reg prev_a;  // Register to store the previous state of 'a'
reg rise_reg, down_reg;  // Registers for output signals

// Initialize registers and outputs at the start of the module
initial begin
    prev_a = 1'b0;
    rise_reg = 1'b0;
    down_reg = 1'b0;
end

// Assign output signals
assign rise = rise_reg;
assign down = down_reg;

// Sequential logic to store the previous state of 'a' and detect edges
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset all registers and outputs
        prev_a <= 1'b0;
        rise_reg <= 1'b0;
        down_reg <= 1'b0;
    end else begin
        // Store the current state of 'a' in the previous state register
        prev_a <= a;
        
        // Edge detection logic
        if (a && !prev_a) begin
            // Rising edge detected
            rise_reg <= 1'b1;
            down_reg <= 1'b0;
        end else if (!a && prev_a) begin
            // Falling edge detected
            rise_reg <= 1'b0;
            down_reg <= 1'b1;
        end else begin
            // No edge detected, reset the signals
            rise_reg <= 1'b0;
            down_reg <= 1'b0;
        end
    end
end

endmodule