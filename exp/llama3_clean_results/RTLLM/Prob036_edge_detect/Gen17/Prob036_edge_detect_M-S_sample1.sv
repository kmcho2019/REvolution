module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output reg    rise,     // Output signal indicating a rising edge
    output reg    down      // Output signal indicating a falling edge
);

reg prev_a;  // Register to store the previous value of 'a'

// Sequential logic to store the previous value of 'a'
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the previous value of 'a' to 0
        prev_a <= 1'b0;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        // Update the previous value of 'a'
        prev_a <= a;
        // Reset the output signals after one clock cycle
        rise <= 1'b0;
        down <= 1'b0;
    end
end

// Combinational logic to generate the output signals
always @(*) begin
    if (a && !prev_a) begin
        // Rising edge detected
        rise = 1'b1;
    end else begin
        rise = 1'b0;
    end
    
    if (!a && prev_a) begin
        // Falling edge detected
        down = 1'b1;
    end else begin
        down = 1'b0;
    end
end

endmodule