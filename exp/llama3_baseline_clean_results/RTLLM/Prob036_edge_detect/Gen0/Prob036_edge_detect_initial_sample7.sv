module edge_detect(
    input clk,       // Clock signal
    input rst_n,     // Reset signal (active low)
    input a,        // Input signal
    output rise,    // Output signal indicating a rising edge
    output down     // Output signal indicating a falling edge
);

reg prev_a;         // Register to store the previous value of "a"
reg rise_reg;       // Register to store the value of rise
reg down_reg;       // Register to store the value of down

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        prev_a <= 0;  // Initialize prev_a to 0 on reset
        rise_reg <= 0;  // Initialize rise_reg to 0 on reset
        down_reg <= 0;  // Initialize down_reg to 0 on reset
    end else begin
        prev_a <= a;  // Store the current value of "a" on the next clock
        rise_reg <= (a == 1 && prev_a == 0) ? 1 : 0;  // Check for rising edge
        down_reg <= (a == 0 && prev_a == 1) ? 1 : 0;  // Check for falling edge
    end
end

assign rise = rise_reg;  // Assign the value of rise_reg to rise
assign down = down_reg;  // Assign the value of down_reg to down

endmodule