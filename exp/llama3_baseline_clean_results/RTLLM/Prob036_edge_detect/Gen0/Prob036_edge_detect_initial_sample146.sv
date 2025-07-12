module edge_detect(
    input clk,      // Clock signal
    input rst_n,    // Reset signal (active low)
    input a,       // Input signal
    output rise,   // Output signal indicating a rising edge
    output down    // Output signal indicating a falling edge
);

reg prev_a;        // Previous state of the input signal "a"
reg rise_reg;      // Register to store the rise output signal
reg down_reg;      // Register to store the down output signal

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        prev_a <= 0;    // Reset the previous state of "a" to 0
        rise_reg <= 0; // Reset the rise output signal to 0
        down_reg <= 0; // Reset the down output signal to 0
    end else begin
        prev_a <= a;   // Update the previous state of "a"
        
        // Check for rising edge
        if (a == 1 && prev_a == 0) begin
            rise_reg <= 1; // Set the rise output signal to 1
        end else begin
            rise_reg <= 0; // Set the rise output signal to 0
        end
        
        // Check for falling edge
        if (a == 0 && prev_a == 1) begin
            down_reg <= 1; // Set the down output signal to 1
        end else begin
            down_reg <= 0; // Set the down output signal to 0
        end
    end
end

assign rise = rise_reg;   // Assign the rise output signal
assign down = down_reg;  // Assign the down output signal

endmodule