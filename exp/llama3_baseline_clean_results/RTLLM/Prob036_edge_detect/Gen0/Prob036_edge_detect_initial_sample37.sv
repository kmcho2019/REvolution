module edge_detect (
    input clk,        // Clock signal
    input rst_n,      // Reset signal (active low)
    input a,          // Input signal
    output reg rise,  // Output signal indicating a rising edge
    output reg down   // Output signal indicating a falling edge
);

reg prev_a;  // Register to store the previous state of 'a'

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin  // Reset condition
        prev_a <= 1'b0;  // Initialize previous state to 0
        rise <= 1'b0;    // Initialize rise signal to 0
        down <= 1'b0;    // Initialize down signal to 0
    end else begin
        prev_a <= a;  // Update previous state on the rising edge of the clock
        if (a == 1'b1 && prev_a == 1'b0) begin  // Check for rising edge
            rise <= 1'b1;  // Set rise signal to 1
            down <= 1'b0;  // Set down signal to 0
        end else if (a == 1'b0 && prev_a == 1'b1) begin  // Check for falling edge
            rise <= 1'b0;  // Set rise signal to 0
            down <= 1'b1;  // Set down signal to 1
        end else begin
            rise <= 1'b0;  // Set rise signal to 0 if no rising edge
            down <= 1'b0;  // Set down signal to 0 if no falling edge
        end
    end
end

endmodule