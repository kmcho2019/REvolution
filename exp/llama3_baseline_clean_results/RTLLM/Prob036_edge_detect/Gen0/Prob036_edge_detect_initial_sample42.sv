module edge_detect (
    input clk,        // Clock signal
    input rst_n,      // Reset signal (active low)
    input a,          // Input signal
    output rise,      // Output signal indicating a rising edge
    output down       // Output signal indicating a falling edge
);

reg prev_a;           // Register to store the previous state of 'a'
reg rise_reg;         // Register to store the rise output
reg down_reg;         // Register to store the down output

// Initialize the output signals to 0
assign rise = rise_reg;
assign down = down_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the registers to 0 when rst_n is low
        prev_a <= 0;
        rise_reg <= 0;
        down_reg <= 0;
    end else begin
        // Update the previous state of 'a'
        prev_a <= a;

        // Check for rising and falling edges
        if (a && ~prev_a) begin
            // Rising edge detected, set 'rise' to 1
            rise_reg <= 1;
            down_reg <= 0;
        end else if (~a && prev_a) begin
            // Falling edge detected, set 'down' to 1
            rise_reg <= 0;
            down_reg <= 1;
        end else begin
            // No edge detected, set both outputs to 0
            rise_reg <= 0;
            down_reg <= 0;
        end
    end
end

endmodule