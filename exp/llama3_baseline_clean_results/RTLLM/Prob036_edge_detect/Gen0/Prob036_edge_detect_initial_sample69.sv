module edge_detect (
    input  clk,    // Clock signal
    input  rst_n,  // Reset signal (active low)
    input  a,     // Input signal
    output rise,  // Output signal indicating a rising edge
    output down   // Output signal indicating a falling edge
);

reg prev_a;  // Register to store the previous state of signal a
reg rise_reg;  // Register to store the rise signal
reg down_reg;  // Register to store the down signal

// Initialize the rise and down signals to 0
initial begin
    rise_reg = 1'b0;
    down_reg = 1'b0;
end

// Detect rising and falling edges on the positive edge of the clock
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Reset
        prev_a <= 1'b0;
        rise_reg <= 1'b0;
        down_reg <= 1'b0;
    end else begin
        // Store the previous state of signal a
        prev_a <= a;

        // Detect rising edge
        if (a == 1'b1 && prev_a == 1'b0) begin
            rise_reg <= 1'b1;
            down_reg <= 1'b0;
        end
        // Detect falling edge
        else if (a == 1'b0 && prev_a == 1'b1) begin
            rise_reg <= 1'b0;
            down_reg <= 1'b1;
        end
        // No edge detected
        else begin
            rise_reg <= 1'b0;
            down_reg <= 1'b0;
        end
    end
end

// Assign the output signals
assign rise = rise_reg;
assign down = down_reg;

endmodule