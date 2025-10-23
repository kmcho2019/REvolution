module edge_detect (
    input clk,        // Clock signal
    input rst_n,      // Reset signal (active low)
    input a,         // Input signal
    output reg rise, // Output signal indicating a rising edge
    output reg down  // Output signal indicating a falling edge
);

reg prev_a; // Register to store the previous state of 'a'

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        prev_a <= 1'b0; // Reset previous state
        rise <= 1'b0;  // Reset 'rise' signal
        down <= 1'b0; // Reset 'down' signal
    end else begin
        prev_a <= a; // Update previous state
        if (a && !prev_a) begin // Rising edge condition
            rise <= 1'b1; // Set 'rise' signal
            down <= 1'b0; // Reset 'down' signal
        end else if (!a && prev_a) begin // Falling edge condition
            rise <= 1'b0; // Reset 'rise' signal
            down <= 1'b1; // Set 'down' signal
        end else begin // No edge condition
            rise <= 1'b0; // Reset 'rise' signal
            down <= 1'b0; // Reset 'down' signal
        end
    end
end

endmodule