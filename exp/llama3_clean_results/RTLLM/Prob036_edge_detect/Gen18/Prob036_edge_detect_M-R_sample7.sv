module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output        rise,     // Output signal indicating a rising edge
    output        down      // Output signal indicating a falling edge
);

reg prev_a;  // Register to store the previous value of 'a'
reg rise_reg;  // Register to store the value of rise
reg down_reg;  // Register to store the value of down

// Sequential logic to store the previous value of 'a' and generate output signals
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the previous value of 'a' and output signals to 0
        prev_a <= 1'b0;
        rise_reg <= 1'b0;
        down_reg <= 1'b0;
    end else begin
        // Update the previous value of 'a'
        prev_a <= a;
        
        // Generate output signals
        if (a && !prev_a) begin
            // Rising edge detected
            rise_reg <= 1'b1;
        end else begin
            rise_reg <= 1'b0;
        end
        
        if (!a && prev_a) begin
            // Falling edge detected
            down_reg <= 1'b1;
        end else begin
            down_reg <= 1'b0;
        end
    end
end

// Continuous assignments to drive output signals
assign rise = rise_reg;
assign down = down_reg;

endmodule