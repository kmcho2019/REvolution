module edge_detect (
    input clk,         // Clock signal
    input rst_n,       // Reset signal (active low)
    input a,           // Input signal
    output rise,       // Output signal indicating a rising edge
    output down        // Output signal indicating a falling edge
);

reg prev_a;            // Register to store the previous state of 'a'
reg rise_reg;          // Register for the rise output signal
reg down_reg;          // Register for the down output signal

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Reset
        prev_a <= 1'b0;
        rise_reg <= 1'b0;
        down_reg <= 1'b0;
    end else begin
        prev_a <= a;  // Store the current state of 'a' for the next clock cycle
        if (a &&!prev_a) begin  // Rising edge detected
            rise_reg <= 1'b1;
            down_reg <= 1'b0;
        end else if (!a && prev_a) begin  // Falling edge detected
            down_reg <= 1'b1;
            rise_reg <= 1'b0;
        end else begin  // No edge detected
            rise_reg <= 1'b0;
            down_reg <= 1'b0;
        end
    end
end

assign rise = rise_reg;  // Continuous assignment for the rise output signal
assign down = down_reg;  // Continuous assignment for the down output signal

endmodule